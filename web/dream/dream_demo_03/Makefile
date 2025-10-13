.PHONY: build run clean init-db

build:
	opam exec -- dune build

run:
	opam exec -- dune exec dream_demo_03

clean:
	opam exec -- dune clean
	rm -f db.sqlite

init-db:
	sqlite3 db.sqlite < init_db.sql

setup:
	opam install --deps-only --yes .
	$(MAKE) init-db

dev: init-db
	$(MAKE) run
