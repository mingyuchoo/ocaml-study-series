# minimo

간단한 OCaml 예제로, 표준 출력에 메시지를 출력하는 최소 코드입니다. 이 코드는 OCaml 공식 문서의 "Your First OCaml Program"를 참고하여 작성되었습니다.

## 개요

- **목표**: OCaml 빌드/실행 흐름(dune, make)을 빠르게 체험
- **핵심 파일**: `minimo.ml` (메인 엔트리)

## 프로젝트 구조

```shell
./
├─ .ocamlformat
├─ Makefile
├─ README.org
├─ README.md
├─ dune
├─ dune-project
└─ minimo.ml
```

- **`minimo.ml`**: 프로그램 엔트리. 콘솔에 문자열을 출력합니다.
- **`dune` / `dune-project`**: dune 빌드 설정 파일입니다.
- **`Makefile`**: 빌드, 테스트, 실행 등 자주 쓰는 명령을 래핑합니다.
- **`.ocamlformat`**: 코드 포매팅 설정입니다.

## 사전 준비물

- **OCaml** 및 **opam**
- **dune** (opam으로 자동 설치 가능)

필요 시 opam 초기 설정과 dune 설치는 다음과 같이 진행할 수 있습니다.

```shell
opam update
opam switch list-available ocaml
# 예시: opam switch create 5.2.1 ocaml-base-compiler.5.2.1
opam install dune
```

## Makefile 작업 흐름

`Makefile`에는 다음 타겟이 준비되어 있습니다.

- **clean**: 빌드 산출물 정리
- **format**: 코드 포맷팅(`@fmt`)
- **doc**: 문서 빌드(`@doc`)
- **build**: 빌드 실행
- **test**: 테스트 실행 (`dune runtest -f`)
- **utop**: utop 실행
- **watch**: 변경 감지 실행(프로젝트 이름 기준)
- **run**: 바이너리 실행

전체 플로우(클린→포맷→문서→빌드→테스트→실행)를 한 번에 돌리려면 다음과 같이 사용할 수 있습니다.

```shell
make all
```

개별 명령은 다음과 같이 실행합니다.

```shell
# 정리
make clean

# 포맷팅
make format

# 문서 빌드
make doc

# 빌드
make build

# 테스트 (현재 예제에는 별도 테스트가 없을 수 있습니다)
make test

# 실행
make run
```

Makefile 내부에서는 opam 환경을 사용해 dune을 호출하므로, opam 스위치가 활성화된 셸에서 실행하는 것을 권장합니다.

## 직접 dune으로 실행하기

원한다면 dune만으로도 실행할 수 있습니다.

```shell
opam exec -- dune build
opam exec -- dune exec "./minimo.exe"
```

## 프로그램 동작

실행 시 표준 출력에 다음과 같은 메시지를 출력합니다.

```shell
My name is Minimo
```

## 참고 자료(Reference)

- A Tour of OCaml: <https://ocaml.org/docs/tour-of-ocaml>
- Your First OCaml Program: <https://ocaml.org/docs/your-first-program>

## 라이선스

이 저장소의 라이선스 정책이 명시되지 않았다면, 저장소 최상단의 추가 문서를 참고하거나 저장소 소유자에게 문의하세요.
