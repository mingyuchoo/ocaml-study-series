# README

## How to create a OCaml project

```bash
$ opam exec -- dune init project <project_name>
$ cd <project_name>

# Edit source files

$ opam exec -- dune test
$ opam exec -- dune doc
$ opam exec -- dune build
$ opam exec -- dune exec ./bin/main.exe
```
