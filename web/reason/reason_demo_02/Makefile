.PHONY: build test

CURRENT_DIR := $(notdir $(CURDIR))

all: clean format doc build test run

install:
	opam install reason
	opam install --deps-only --yes . --with-test --yes

deps:
	opam install dream caqti caqti-driver-sqlite3 caqti-lwt lwt yojson --yes

clean:
	opam exec -- dune clean

format:
	opam exec -- dune build @fmt --auto-promote

doc:
	opam exec -- dune build @doc

build:
	opam exec -- dune build

test:
	opam exec -- dune runtest -f

utop:
	opam exec -- dune utop

watch:
	opam exec -- dune exec --watch "$(CURRENT_DIR)"

run:
	opam exec -- dune exec "$(CURRENT_DIR)"
