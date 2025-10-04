# README

## Installation

### OCaml Package Manager

```shell
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
opam init -y
eval $(opam env)
which ocaml
ocaml -version
```

### Build system

```shell
opam install dune ocaml-lsp-server odoc ocamlformat utop
opam install merlin menhir mirage
```

### Reason

```shell
opam install reason
```

You will have available the following tools:
- `refmt`
- `rtop`

## Create a first project

```shell
opam exec -- dune init project {project_name}
cd {project_name}
```

### Change file to reason extension

```shell
mv bin/main.ml bin/main.re
```

### Change content of `main.re`

```reason
print_endline("Hello world!");
```

### Build

```shell
opam exec -- dune clean
opam exec -- dune build @fmt
opam exec -- dune build @doc
opam exec -- dune build
opam exec -- dune runtest -f
opam exec -- dune exec $(basename ${PWD})
```

## References

- [REASON](https://reasonml.github.io/en/)