# README

## Project setting

### Install essential tools

Install OCaml with `opam`
```shell
opam install ocaml dune
```

Install `Dream` package
```shell
opam install dream
```

### Create a project
```shell
opam exec dune init project {project_name}
```

### Add `Dream` package to `bin/dune` file
```ocaml
(executable
  (public_name {project_name})
  (name main)
  (libraries {project_name} dream))
```

## Write code to `main.ml` file
```ocaml
let () =
  Dream.run(fun _ ->
    Dream.html "Good morning, world!")
```

## Run project

### Build and execute
```shell
opam install --deps-only --yes .
opam exec -- dune exec $(basename ${PWD})
opam install dream caqti-driver-sqlite3 lwt_ppx ppx_yojson_conv
opam install --deps-only --yes .
```

## Check the functionalities

If you go to [http://localhost:8080](http://localhost:8080), You can see `Good morning, world!`

## References

- [Dream Examples](https://github.com/aantron/dream/tree/master/example)