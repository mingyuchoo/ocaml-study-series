# ocaml-study-series

## Install Ocaml Package Manager `opam`

```bash
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```

## Install OCaml Compiler

```bash
opam init
eval $(opam env)
which ocaml
ocaml -version
```

## Install the Dune build system

```bash
opam install dune
```

### Initializing Projects

``` bash
dune init --help
```

#### Initializing an executable

```bash
dune init proj <project_name>
cd <project_name>/
dune build
dune test
dune exec <project_name>
```

#### Initializing a Library

``` bash
dune init proj --kind=lib <project_name>
cd <project_name>/
dune build
dune test
```

## Install the OCaml language server

``` bash
opam install ocaml-lsp-server
opam install merlin # for VIM and Emacs
```

## References

-<https://ocaml.org/docs/install.html>
-<https://opam.ocaml.org/>
-<https://dune.readthedocs.io/en/latest/quick-start.html>
