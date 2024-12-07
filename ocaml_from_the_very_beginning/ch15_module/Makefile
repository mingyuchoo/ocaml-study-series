.PHONY: build test

CURRENT_DIR := $(notdir $(CURDIR))

all: clean format doc build test run

install:
	#opam update
	#opam upgrade
	opam install dream

clean:
	opam exec -- dune clean

format:
	opam exec -- dune build @fmt

doc:
	opam exec -- dune build @doc

build:
	opam exec -- dune build

test:
	opam exec -- dune test

run:
	opam exec -- dune exec "$(CURRENT_DIR)" gregor.txt
