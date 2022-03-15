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

### Create a first project

```bash
mkdir <project-name>
cd <project-name>/
dune init exe <project-name>
dune build
dune exec ./<project-name>.exe

```

## Install the OCaml language server

``` bash
opam install ocaml-lsp-server
opam install merlin # for VIM and Emacs
```
