# OCaml Plugin System

A dynamic plugin system for OCaml using Dynlink, demonstrating runtime plugin loading and execution with a clean, type-safe architecture.

## Overview

This project implements a minimal yet complete plugin system that allows OCaml applications to dynamically load and execute plugins at runtime. The system consists of three main components:

- **plugin_interface**: Shared library defining the plugin contract
- **plugin_manager**: Main application that loads and executes plugins
- **plugin_hello**: Demo plugin that prints "Hello, OCaml!"

## Project Structure

```
.
├── dune-workspace              # Workspace configuration
├── dune-project                # Project metadata
├── README.md                   # This file
├── plugin_interface/           # Plugin interface library
│   ├── lib/
│   │   ├── dune
│   │   └── plugin_interface.ml # PLUGIN module type definition
│   └── test/                   # Tests
├── plugin_manager/             # Plugin Manager
│   ├── bin/
│   │   ├── dune
│   │   └── main.ml             # Plugin loader and executor
│   ├── lib/
│   │   └── dune                # Empty library (for dependencies)
│   └── test/                   # Tests
└── plugins/                    # Plugins directory
    └── plugin_hello/           # Demo plugin
        ├── lib/
        │   ├── dune
        │   └── plugin_hello.ml # "Hello, OCaml!" implementation
        └── test/               # Tests
```

## Building the Project

### Prerequisites

- OCaml (>= 4.08)
- Dune (>= 3.0)

### Build All Components

To build the entire workspace including the core application and all plugins:

```bash
dune build
```

This will compile:
- The plugin interface library
- The core application executable at `_build/default/plugin_manager/bin/main.exe`
- The hello plugin as a dynamically loadable module at `_build/default/plugins/plugin_hello/lib/plugin_hello.cmxs`

### Build Individual Components

You can also build specific components:

```bash
# Build only the core application
dune build plugin_manager/bin/main.exe

# Build only the hello plugin
dune build plugins/plugin_hello/lib/plugin_hello.cmxs
```

## Running the Application

### Using dune exec

The recommended way to run the application is using `dune exec`:

```bash
dune exec plugin_manager -- _build/default/plugins/plugin_hello/lib/plugin_hello.cmxs
```

Expected output:
```
Successfully loaded plugin: _build/default/plugins/plugin_hello/lib/plugin_hello.cmxs
Executing plugin: plugin_hello
Hello, OCaml!
Plugin execution completed successfully
```

### Direct Execution

Alternatively, you can run the built executable directly:

```bash
./_build/default/plugin_manager/bin/main.exe _build/default/plugins/plugin_hello/lib/plugin_hello.cmxs
```

### Usage

```bash
plugin_manager <plugin_path>
```

Where `<plugin_path>` is the path to a `.cmxs` plugin file.

## Creating a New Plugin

Follow these steps to create your own plugin:

### 1. Create Plugin Directory

```bash
mkdir -p plugins/my_plugin/lib
```

### 2. Write Plugin Implementation

Create `plugins/my_plugin/lib/my_plugin.ml`:

```ocaml
(* My custom plugin implementation *)

let name () = "my_plugin"

let execute () =
  print_endline "This is my custom plugin!";
  print_endline "It can do anything you want!"

(* Register with the plugin system *)
let () =
  let module P = struct
    let name = name
    let execute = execute
  end in
  Plugin_interface.register_plugin (module P : Plugin_interface.PLUGIN)
```

### 3. Create Dune Configuration

Create `plugins/my_plugin/lib/dune`:

```lisp
(library
 (public_name my_plugin)
 (name my_plugin)
 (libraries plugin_interface))
```

**Note**: Dune automatically generates `.cmxs` files for libraries when needed. The library will be compiled as a dynamically loadable module at `_build/default/plugins/my_plugin/lib/my_plugin.cmxs`.

### 4. Build and Run

```bash
# Build the new plugin
dune build plugins/my_plugin/lib/my_plugin.cmxs

# Run with the core application
dune exec plugin_manager -- _build/default/plugins/my_plugin/lib/my_plugin.cmxs
```

## Plugin Interface

All plugins must implement the `Plugin_interface.PLUGIN` module type:

```ocaml
module type PLUGIN = sig
  val name : unit -> string      (* Returns the plugin identifier *)
  val execute : unit -> unit     (* Performs the plugin's main functionality *)
end
```

### Plugin Registration

Plugins must register themselves using the registration mechanism:

```ocaml
let () =
  let module P = struct
    let name = name
    let execute = execute
  end in
  Plugin_interface.register_plugin (module P : Plugin_interface.PLUGIN)
```

This registration happens when the plugin module is loaded by Dynlink.

## Error Handling

The core application handles several error scenarios:

- **File Not Found**: If the plugin file doesn't exist, a clear error message is displayed
- **Loading Errors**: Dynlink errors (e.g., incompatible bytecode/native code) are caught and reported
- **Execution Errors**: Exceptions during plugin execution are caught to prevent crashes

Example error output:
```bash
$ dune exec plugin_manager -- nonexistent.cmxs
System error: Plugin file not found: nonexistent.cmxs
```

## Development Tips

### Clean Build

To clean all build artifacts:

```bash
dune clean
```

### Rebuild Everything

```bash
dune clean && dune build
```

### Watch Mode

For development, you can use Dune's watch mode to automatically rebuild on file changes:

```bash
dune build --watch
```

## Architecture Notes

- **Type Safety**: The plugin interface ensures compile-time type checking for all plugins
- **Dynamic Loading**: Uses OCaml's `Dynlink` module for runtime plugin loading
- **First-Class Modules**: Plugins are managed as first-class modules for type-safe dynamic dispatch
- **Workspace Structure**: Dune workspace allows independent development and building of components

## Limitations and Future Enhancements

Current limitations:
- Only one plugin can be loaded at a time
- No plugin configuration or parameter passing
- No plugin dependency management

Potential enhancements:
- Multiple plugin loading and management
- Plugin discovery (auto-scan directories)
- Configuration file support
- Plugin versioning and compatibility checking
- Hot reloading capabilities
- Sandboxing for security

## License

This is a demonstration project for educational purposes.
