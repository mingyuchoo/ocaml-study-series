(* 1. SIGnature: 집합 요소에 필요한 기능을 정의하는 계약 *)
module type COMPARABLE = sig
  (** 't'는 이 모듈이 다룰 요소의 타입입니다. *)
  type t

  (** 두 요소를 비교합니다. *)
  val compare : t -> t -> int
end

(* 2. STRucture: COMPARABLE 서명을 이행하는 정수형 구현체 *)
module IntComparable : COMPARABLE with type t = int = struct
  type t = int

  let compare a b = if a < b then -1 else if a > b then 1 else 0
end

(* 3. FUNCTOR: COMPARABLE 모듈을 받아 Set 모듈을 생성하는 함수 *)
module SetFunctor (Element : COMPARABLE) = struct
  type element = Element.t

  type set = element list (* 간단하게 리스트로 가정 *)

  let insert s x = if List.mem x s then s else x :: s

  let is_member s x = List.exists (fun y -> Element.compare x y = 0) s

  let to_list s = s

  let empty = []
end

(* 4. FUNCTOR 적용: IntComparable 모듈을 SetFunctor의 매개변수로 전달 *)
module IntSet = SetFunctor (IntComparable)
