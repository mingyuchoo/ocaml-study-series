# README

## Install OCaml

```bash
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
$ opam init
$ opam install ocaml-lsp-server odoc ocamlformat utop
```

## Quickstart an OCaml app project using Dune

```bash
$ opam --version
$ opam exec -- dune init project <project_name>
$ cd <project_name>
$ opam exec -- dune test
$ opam exec -- dune doc
$ opam exec -- dune build
$ opam exec -- dune exec ./bin/main.exe
```
