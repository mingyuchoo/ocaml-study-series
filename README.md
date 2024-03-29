<p align="center">
  <a href="https://github.com/mingyuchoo/ocaml-study-series/blob/main/LICENSE"><img alt="license" src="https://img.shields.io/github/license/mingyuchoo/ocaml-study-series"/></a>
  <a href="https://github.com/mingyuchoo/ocaml-study-series/issues"><img alt="Issues" src="https://img.shields.io/github/issues/mingyuchoo/ocaml-study-series?color=appveyor" /></a>
  <a href="https://github.com/mingyuchoo/ocaml-study-series/pulls"><img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/mingyuchoo/ocaml-study-series?color=appveyor" /></a>
</p>

# README

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

#### From initializing to executing an executable

```bash
dune init project <project_name>
cd <project_name>/
dune build
dune test
dune exec <project_name>
```

#### From initializing to testing a Library

``` bash
dune init project --kind=lib <project_name>
cd <project_name>/
dune build
dune test
```

## Install the OCaml language server

``` bash
opam install ocaml-lsp-server
opam install merlin # for VIM and Emacs
```
## Applications written in Ocaml

- <http://ocamlverse.net/content/apps.html>
- <http://ocamlverse.net/content/build_systems.html>

## References

-<https://ocaml.org/docs/install.html>
-<https://opam.ocaml.org/>
-<https://dune.readthedocs.io/en/latest/quick-start.html>
