#! /bin/bash

dune build
dune exe $(basename $PWD) gregor.txt
