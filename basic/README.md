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
$ dune init project project_name
$ cd project_name
$ dune build
$ dune exec ./bin/main.exe
```
