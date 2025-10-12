# Reason Demo 01

A Reason project demonstrating module functors and type signatures.

## Prerequisites

Make sure you have OCaml and Reason installed:

```shell
# Install OCaml package manager
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
opam init -y
eval $(opam env)

# Install build tools and Reason
opam install dune ocaml-lsp-server odoc ocamlformat utop reason
```

## Project Structure

```
├── bin/
│   ├── dune          # Executable configuration
│   └── main.re       # Main Reason source file
├── lib/
│   └── dune          # Library configuration
├── test/
│   ├── dune          # Test configuration
│   └── test_reason_demo_01.ml
├── dune-project      # Project configuration
└── Makefile          # Build automation
```

## Development

### Quick Start

```shell
# Install dependencies
make install

# Build and run
make run
```

### Available Commands

```shell
# Clean build artifacts
make clean

# Format code
make format

# Build documentation
make doc

# Build project
make build

# Run tests
make test

# Start utop REPL
make utop

# Run with file watching
make watch
```

### Manual Commands

```shell
# Clean
opam exec -- dune clean

# Format code
opam exec -- dune build @fmt --auto-promote

# Build documentation
opam exec -- dune build @doc

# Build project
opam exec -- dune build

# Run tests
opam exec -- dune runtest -f

# Execute
opam exec -- dune exec reason_demo_01
```

## What This Demo Shows

The main.re file demonstrates:
- Module type definitions (`Stringable`)
- Functors (modules that take other modules as parameters)
- Module instantiation with specific types
- List processing and string operations

## References

- [Reason Language](https://reasonml.github.io/en/)
- [Dune Build System](https://dune.readthedocs.io/)
- [OCaml Documentation](https://ocaml.org/docs/)