# ch16_opium_webapp

## How to create a project

```sh
dune init proj ch16_opium_webapp --libs opium
```


## How to build, test, and run

```sh
dune build
dune test
dune exec $(basename ${PWD})
```

## How to check the result

connect to `http://localhost:3000/person/john_doe/42`


## References

- <https://github.com/rgrinberg/opium/tree/24caae6c60f71fc071a36ace27f46c79d325c2bf>

