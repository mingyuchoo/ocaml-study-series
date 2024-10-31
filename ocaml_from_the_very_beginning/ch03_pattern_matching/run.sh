#!/usr/bin/env bash

opam exec -- dune clean
opam exec -- dune build @fmt
opam exec -- dune build @doc
opam exec -- dune build
opam exec -- dune test
opam exec -- dune exec $(basename ${PWD})
