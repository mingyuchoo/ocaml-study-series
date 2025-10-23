# README

## 개요(Overview)

이 코드베이스는 "Your First OCaml Program"을 참고하여 작성되었습니다.

## 참고 자료(Reference)

- [A Tour of OCaml](https://ocaml.org/docs/tour-of-ocaml)
- [Your First OCaml Program](https://ocaml.org/docs/your-first-program)

## 프로젝트 구조

```text
.
  bin/
  lib/
    dune
    app.mli                 # 라이브러리 실행 인터페이스: val run : unit -> unit
    app.ml                  # 실행 로직(라이브러리로 이동됨)
    en.mli                  # 문자열 리스트 도우미 인터페이스
    en.ml                   # [%show: string list] 사용, 샘플 데이터 v 제공
    es.ml                   # 스페인어 문자열 예시
  test/
    dune
    test_hello_02.ml        # 테스트 스켈레톤(현재 내용 없음)
  dune-project               # dune 설정(>= 3.20)
  hello_02.opam              # opam 패키지 메타데이터(자동 생성됨)
  .ocamlformat               # 코드 포매팅 설정
  Makefile                   # 빌드/실행/테스트 유틸 타겟 제공
  README.md
```

## 의존성

- 도구: OCaml, opam, dune(3.20 이상)
- 라이브러리: `sexplib`, `ppx_deriving`

설치 예시:

```bash
opam install --deps-only --yes .
# or
opam install -y sexplib ppx_deriving
```

## 빌드/실행/테스트

- 빌드

  ```bash
  dune build
  # 또는
  make build
  ```

- 실행

  ```bash
  dune exec hello_02
  # 또는
  make run
  ```

- 테스트

  ```bash
  dune runtest -f
  # 또는
  make test
  ```

- 포매팅/문서

  ```bash
  dune build @fmt --auto-promote   # 또는 make format
  dune build @doc   # 또는 make doc
  ```

## 코드 개요

- `bin/main.ml`: `Hello_02.App.run ()`만 호출하여 실행 위임.
- `lib/app.ml`: 실행 로직 구현.
  - `Sexplib`으로 S-식 파싱/문자열화 출력.
  - `En.(string_of_string_list v)`로 문자열 리스트 출력.
- `lib/en.ml`/`lib/en.mli`: 문자열 리스트 -> 문자열 변환 도우미와 샘플 데이터 `v` 제공.
- `lib/dune`: `ppx_deriving.show` 프리프로세서, `sexplib` 의존성 선언.
- `bin/dune`: 내부 라이브러리 `hello_02`만 링크.

## 리팩토링 메모

- `bin/main.ml`의 구현을 `lib/app.ml`로 이동하고, 바이너리는 라이브러리 호출만 수행하도록 정리했습니다.
