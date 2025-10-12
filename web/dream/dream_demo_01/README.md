# Dream Demo 01

OCaml Dream web framework demonstration project.

## Project Setup

### Install Essential Tools

Install OCaml with `opam`:
```shell
opam install ocaml dune
```

Install `Dream` and other required packages:
```shell
opam install dream lwt_ppx
```

### Project Structure

This project was created using:
```shell
opam exec dune init project dream_demo_01
```

The project includes:
- `bin/main.ml` - Main application entry point
- `bin/dune` - Executable configuration with Dream and lwt_ppx dependencies
- `lib/dune` - Library configuration
- `dune-project` - Project configuration
- `dream_demo_01.opam` - Package dependencies (auto-generated)

### Dependencies Configuration

The `bin/dune` file is configured with:
```ocaml
(executable
 (public_name dream_demo_01)
 (name main)
 (libraries dream_demo_01 dream)
 (preprocess
  (pps lwt_ppx)))
```

## Application Code

The main application in `bin/main.ml`:
```ocaml
let () = Dream.run (fun _ -> Dream.html "Good morning, world!")
```

## Running the Project

### Install Dependencies and Build
```shell
opam install --deps-only --yes .
```

### Execute the Application
```shell
opam exec -- dune exec dream_demo_01
```

## Testing the Application

Visit [http://localhost:8080](http://localhost:8080) to see "Good morning, world!" displayed in your browser.

## Development Notes

The `main.ml` file contains multiple commented examples showing different Dream features:
- Basic routing
- Middleware usage
- Request counting
- Promise handling with lwt_ppx
- Error handling
- Echo server functionality

Uncomment different sections to explore various Dream capabilities.

## References

- [Dream Examples](https://github.com/aantron/dream/tree/master/example)
- [Dream Documentation](https://aantron.github.io/dream/)