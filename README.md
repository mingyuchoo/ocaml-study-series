<p align="center">
  <a href="https://github.com/mingyuchoo/ocaml-study-series/blob/main/LICENSE"><img alt="license" src="https://img.shields.io/github/license/mingyuchoo/ocaml-study-series"/></a>
  <a href="https://github.com/mingyuchoo/ocaml-study-series/issues"><img alt="Issues" src="https://img.shields.io/github/issues/mingyuchoo/ocaml-study-series?color=appveyor" /></a>
  <a href="https://github.com/mingyuchoo/ocaml-study-series/pulls"><img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/mingyuchoo/ocaml-study-series?color=appveyor" /></a>
</p>

# README

## Install Ocaml Package Manager `opam`

```bash
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

## Install OCaml Compiler

```bash
opam init -y
eval $(opam env)
which ocaml
ocaml -version
```

## Install the Dune build system

```bash
opam install dune ocaml-lsp-server odoc ocamlformat utop
opam install menhir mirage
```

* dune: OCaml 프로젝트의 빌드 시스템입니다.
* menhir: OCaml에서 사용하는 파서 생성기입니다.
* mirage: OCaml을 기반으로 하는 unikernel 시스템입니다.
* ocaml-lsp-server: OCaml 언어 서버 프로토콜(LSP) 서버입니다.
* ocamlformat: OCaml 코드의 자동 코드 포매터입니다.
* odoc: OCaml 코드의 문서를 생성하는 도구입니다.
* opam: OCaml 패키지 관리자입니다.
* utop: OCaml의 상호작용적 최상위(top-level) 인터프리터입니다.

### Initialize a project

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
