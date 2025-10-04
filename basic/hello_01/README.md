# README

## How to create a OCaml project

```shell
opam exec -- dune init project <project_name>
cd <project_name>
# Edit source files
opam exec -- dune clean
opam exec -- dune build @fmt
opam exec -- dune build @doc
opam exec -- dune build
opam exec -- dune test
opam exec -- dune exec $(basename ${PWD})
```