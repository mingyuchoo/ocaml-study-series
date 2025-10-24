# README

## Project setting

### Install essential tools

Install OCaml with `opam`
```shell
opam install ocaml dune
```

Install `Dream` and other packages
```shell
opam install dream caqti-driver-sqlite3 ppx_yojson_conv
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
opam install dream caqti-driver-sqlite3 lwt_ppx ppx_yojson_conv
opam exec -- dune exec $(basename ${PWD})
```

## Check the functionalities

If you go to [http://localhost:8080](http://localhost:8080), You can see `Good morning, world!`

## References

- [Dream Examples](https://github.com/aantron/dream/tree/master/example)
