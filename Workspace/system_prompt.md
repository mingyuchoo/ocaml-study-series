# System Prompt

- OCaml 프로젝트를 Dune 빌드 시스템 기반 Workspace 구조로 만드려고 한다.
- Workspace 구조는 Clean Architecture를 따르는 모듈화된 디렉토리 구조를 사용하라. 각 폴더는 독립적인 Dune 프로젝트가 되어야 한다.

```text
my_workspace/
├── dune-workspace
├── domain/
│   ├── dune
│   └── lib_a.ml
├── application/
│   ├── dune
│   └── main.ml
├── infrastructure/
│   ├── dune
│   └── main.ml
└── presentation/
    ├── dune
    └── utils.ml
```
