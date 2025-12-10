# Signature-Structure-Functor in OCaml

ML의 Signature-Structure-Functor 메커니즘은 모듈 간의 계약(contract)과 매개변수적 의존성을 공식화하는 데 매우 강력하고 명시적인 언어 구조를 제공하는 예시 코드베이스입니다.

## ML 모듈 시스템의 핵심 개념

### Structure (구조체)
- 실제 구현(값, 타입, 함수 등)을 포함하는 모듈의 "값"
- 구체적인 데이터 타입과 함수들의 실제 구현을 담고 있음

### Signature (서명)
- 구조체의 인터페이스 또는 타입을 정의
- 어떤 값과 타입이 외부로 노출되는지 명시
- 시그니처를 통해 구조체를 **제한(sealing)**하면, 서명에 명시되지 않은 내부 구현은 완전히 숨겨짐

### Functor (함수자)
- 모듈을 입력으로 받아 새로운 모듈을 출력하는 모듈 수준의 함수
- 매개변수적 모듈화를 가능하게 하여, 핵심 로직은 그대로 두고 의존하는 모듈만 바꿔서 재사용 가능
- 예: 어떤 타입이든 처리할 수 있는 일반적인 Set 모듈을 만들고, 정렬 가능한 타입을 제공하는 모듈을 인수로 받아 특정 Set 모듈을 생성

## 강력한 데이터 추상화

시그니처를 사용하여 타입 정의를 추상화하면(manifest type 대신 abstract type), 모듈 사용자는 해당 타입의 구현이 무엇인지 전혀 알 수 없으며, 서명에 명시된 함수만을 통해서만 조작할 수 있습니다. 이는 하스켈보다 더 강력한 수준의 정보 은닉을 제공합니다.

## How to create a OCaml project

```shell
opam exec -- dune init project <project_name>
cd <project_name>
# Edit source files
opam install --deps-only --yes .
opam exec -- dune clean
opam exec -- dune build @fmt --auto-promote
opam exec -- dune build @doc
opam exec -- dune build
opam exec -- dune runtest -f
opam exec -- dune exec $(basename ${PWD})
```

## 실제 예시

### 1. Signature와 Structure 예시

```ocaml
(* 서명 정의 - 인터페이스 *)
module type STACK = sig
  type 'a t
  val empty : 'a t
  val push : 'a -> 'a t -> 'a t
  val pop : 'a t -> ('a * 'a t) option
  val is_empty : 'a t -> bool
end

(* 구조체 - 실제 구현 *)
module ListStack : STACK = struct
  type 'a t = 'a list
  let empty = []
  let push x xs = x :: xs
  let pop = function
    | [] -> None
    | x :: xs -> Some (x, xs)
  let is_empty xs = xs = []
end
```

### 2. Functor 예시

```ocaml
(* 비교 가능한 타입의 서명 *)
module type COMPARABLE = sig
  type t
  val compare : t -> t -> int
end

(* Set을 만드는 Functor *)
module MakeSet (Ord : COMPARABLE) = struct
  type elt = Ord.t
  type t = elt list
  
  let empty = []
  
  let rec insert x = function
    | [] -> [x]
    | y :: ys ->
        match Ord.compare x y with
        | c when c < 0 -> x :: y :: ys
        | 0 -> y :: ys  (* 중복 제거 *)
        | _ -> y :: insert x ys
end

(* 정수용 Set 생성 *)
module IntSet = MakeSet(struct
  type t = int
  let compare = compare
end)

(* 문자열용 Set 생성 *)
module StringSet = MakeSet(struct
  type t = string
  let compare = String.compare
end)
```

### 3. Abstract Type을 통한 강력한 캡슐화

```ocaml
(* 추상 타입을 사용한 서명 *)
module type COUNTER = sig
  type t  (* 추상 타입 - 구현이 숨겨짐 *)
  val create : unit -> t
  val increment : t -> t
  val get_value : t -> int
end

module Counter : COUNTER = struct
  type t = int ref  (* 실제 구현은 숨겨짐 *)
  let create () = ref 0
  let increment counter = incr counter; counter
  let get_value counter = !counter
end

(* 사용자는 Counter.t의 실제 구현을 알 수 없고,
   오직 제공된 함수들을 통해서만 조작 가능 *)
```

## 장점

1. **타입 안전성**: 컴파일 타임에 모듈 간 계약이 검증됨
2. **코드 재사용**: Functor를 통한 매개변수적 모듈화
3. **정보 은닉**: Abstract type을 통한 강력한 캡슐화
4. **모듈성**: 명확한 인터페이스를 통한 모듈 간 분리
5. **유지보수성**: 서명이 변경되지 않는 한 구현 변경이 자유로움