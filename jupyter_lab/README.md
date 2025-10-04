# How to use OCaml as a kernel on Jupyter Notebook

## On Ubuntu

Install some packages:

```shell
sudo apt-get install -y zlib1g-dev libffi-dev libgmp-dev libzmq5-dev
opam install jupyter
```

Create a file `~/.ocamlinit`:

```ocaml
#use "topfind";;
Topfind.log:=ignore;;
```

Install OCaml kernel in Jupyter:

```shell
ocaml-jupyter-opam-genspec
jupyter kernelspec install --user --name ocaml-jupyter "$(opam var share)/jupyter"
```

Run Jupyter Notebook and choose OCaml as a kernel:

```shell
jupyter notebook
```