# README

## How to create a project

```shell
opam exec -- dune init project {project_name} --lib opium
cd {project_name}
```

## How to run server

```shell
make run
```

## How to connect to server

```shell
curl http://localhost:3000/person/john_doe/42
```

## Fix Opium Errors

If you encounter the error below,

```
Response.of_plain_text "Hello World" |> Lwt.return
^^^^^^^^^^^^^^^^^^^^^^
Error: Unbound module Response
make: *** [Makefile:31: run] Error 1
```

upgrade you opium package

```shell
opam upgrade opium
```

## References

- [Opium](https://github.com/rgrinberg/opium/tree/master?tab=readme-ov-file)