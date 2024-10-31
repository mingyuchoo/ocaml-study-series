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

- dune: OCaml 프로젝트의 빌드 시스템입니다.
- menhir: OCaml에서 사용하는 파서 생성기입니다.
- merlin: OCaml 코드에 대한 강력한 편집기 지원을 제공하는 도구입니다.
- mirage: OCaml을 기반으로 하는 unikernel 시스템입니다.
- ocaml-lsp-server: OCaml 언어 서버 프로토콜(LSP) 서버입니다.
- ocamlformat: OCaml 코드의 자동 코드 포매터입니다.
- odoc: OCaml 코드의 문서를 생성하는 도구입니다.
- opam: OCaml 패키지 관리자입니다.
- utop: OCaml의 상호작용적 최상위(top-level) 인터프리터입니다.

### Initialize a project

```bash
opam exec -- dune init --help
```

#### From initializing to executing an executable

```bash
opam --version
opam exec -- dune init project <project_name>
cd <project_name>
opam exec -- dune fmt
opam exec -- dune build @doc
opam exec -- dune build
oopam exec -- dune test
pam exec -- dune exec ./bin/main.exe
```

#### From initializing to testing a Library

```bash
opam exec -- dune init project --kind=lib <project_name>
cd <project_name>
opam exec -- dune fmt
opam exec -- dune build @doc
opam exec -- dune build
opam exec -- dune test
```

## Install the OCaml language server

```bash
opam install ocaml-lsp-server
opam install merlin # for VIM and Emacs
```

## Formatting code with OCamlFormat

Create a `.ocamlformat` configuration file at the root of the project.

```bash
echo "version = `ocamlformat --version`" > .ocamlformat
opam exec -- dune fmt
```

## How to use Ocaml as a kernel on Jupyter Notebook

### on Ubuntu

Install some packages

```bash
sudo apt-get install -y zlib1g-dev libffi-dev libgmp-dev libzmq5-dev
opam install jupyter
```

Create a file `~/.ocamlinit`

```ocaml
#use "topfind";;
Topfind.log:=ignore;;
```

Install Ocaml kernel in Jupyter

```bash
ocaml-jupyter-opam-genspec
jupyter kernelspec install --user --name ocaml-jupyter "$(opam var share)/jupyter"
```

Run Jupyter Notebook and choose OCaml as a kernel

```bash
jupyter notebook
```


## Applications written in Ocaml

- <http://ocamlverse.net/content/apps.html>
- <http://ocamlverse.net/content/build_systems.html>

## References

- <https://ocaml.org/docs/install.html>
- <https://opam.ocaml.org/>
- <https://dune.readthedocs.io/en/latest/quick-start.html>
