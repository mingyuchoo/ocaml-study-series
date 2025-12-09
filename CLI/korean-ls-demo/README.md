# Korean Language Server (korean-ls-demo)

Language Server Protocol implementation for Korean programming language with VSCode extension support.

## Overview

An OCaml-based Language Server that provides IDE features for Korean programming language (`.kr` files), including syntax checking, auto-completion, hover information, and go-to-definition.

## Features

- **Syntax Highlighting**: Full syntax support for `.kr` files
- **Real-time Diagnostics**: Syntax and semantic error detection
- **Code Completion**: Intelligent auto-completion suggestions
- **Hover Information**: Context-aware documentation on hover
- **Go to Definition**: Navigate to symbol definitions
- **Symbol Analysis**: Built-in symbol table and analyzer

## Project Structure

```
.
├── bin/                    # Language server executable
├── lib/                    # Core OCaml libraries
│   ├── analyzer/          # Code analysis and symbol table
│   ├── document/          # Document management
│   ├── lsp/              # LSP protocol implementation
│   ├── parser/           # Korean language parser
│   ├── providers/        # LSP feature providers
│   └── utils/            # Utilities and logging
├── test/                  # Test files and integration tests
├── vscode-extension/      # VSCode extension
└── docs/                  # Documentation
```

## Requirements

- **OCaml**: >= 5.3
- **Dune**: >= 3.20
- **Dependencies**: yojson, ppx_deriving_yojson
- **Node.js**: For VSCode extension development

## Installation

### 1. Build the Language Server

```bash
# Install OCaml dependencies
opam install --deps-only --yes .

# Build the language server
dune build

# The executable will be at _build/default/bin/main.exe
```

### 2. Install VSCode Extension

```bash
cd vscode-extension

# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Package extension (optional)
npm run package

# Install extension
code --install-extension korean-language-server-*.vsix
```

## Configuration

Configure the extension in VSCode settings:

```json
{
  "koreanLanguageServer.serverPath": "/path/to/_build/default/bin/main.exe",
  "koreanLanguageServer.logLevel": "info",
  "koreanLanguageServer.trace.server": "off"
}
```

### Available Settings

- `koreanLanguageServer.serverPath`: Path to the Korean Language Server executable
- `koreanLanguageServer.logLevel`: Log level (debug, info, warning, error)
- `koreanLanguageServer.trace.server`: LSP communication trace (off, messages, verbose)

## Development

### Language Server Development

```bash
# Build in watch mode
dune build --watch

# Run tests
dune test

# Format code
dune build @fmt --auto-promote
```

### Extension Development

```bash
cd vscode-extension

# Watch mode for TypeScript
npm run watch

# Debug: Press F5 in VSCode to launch Extension Development Host
```

## Logging and Debugging

The language server logs to `~/.korean-ls.log` by default.

### Check Logs

```bash
# Use the provided script
./check_logs.sh

# Or manually
tail -f ~/.korean-ls.log
```

### Test Logger

```bash
# Run logger test
dune exec test/test_logger.exe
```

## Status Bar

The VSCode extension shows the language server status in the status bar:

- `$(loading~spin) Korean LS`: Starting
- `$(check) Korean LS`: Running
- `$(circle-slash) Korean LS`: Stopped
- `$(error) Korean LS`: Error
- `$(sync~spin) Korean LS`: Restarting

## Testing

See the `docs/` directory for comprehensive testing guides:

- `TEST_README.md`: Overview of testing approach
- `INTEGRATION_TEST_GUIDE.md`: Integration testing guide
- `MANUAL_TEST_CHECKLIST.md`: Manual testing checklist
- `QUICK_TEST_REFERENCE.md`: Quick reference for common tests

## Architecture

### Core Components

- **Parser**: Parses Korean language syntax into AST
- **Analyzer**: Performs semantic analysis and builds symbol tables
- **Document Manager**: Manages open documents and their state
- **LSP Protocol**: Implements Language Server Protocol
- **Providers**: Implements LSP features (completion, hover, definition, etc.)

### VSCode Extension Components

- **Client**: Manages language server lifecycle
- **Configuration**: Handles extension settings
- **Extension**: Main extension entry point with commands and status bar

## License

See LICENSE file for details.

## Maintainer

Maintainer Name <maintainer@example.com>

## Contributing

Bug reports and contributions are welcome at the project repository.
