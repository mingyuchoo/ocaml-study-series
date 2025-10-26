.PHONY: build test

CURRENT_DIR := $(notdir $(CURDIR))

all: switch clean format doc build test run

switch:
	opam switch default
	eval $$(opam env)

install:
	opam update
	opam upgrade

clean:
	opam exec -- dune clean

format:
	opam exec -- dune build @fmt --auto-promote

doc:
	opam exec -- dune build @doc

build:
	opam exec -- dune build @all

test:
	opam exec -- dune runtest -f

utop:
	opam exec -- dune utop

watch:
	opam exec -- dune exec --watch "$(CURRENT_DIR)"

run:
	opam exec -- dune exec plugin_manager/plugin_manager.exe -- _build/default/plugin_hello/plugin_hello.cmxs
