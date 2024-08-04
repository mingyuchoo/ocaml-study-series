#!/usr/bin/env bash

dune build
dune exe $(basename $PWD)
