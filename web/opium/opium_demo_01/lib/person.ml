(* 도메인 엔티티: Person *)

(* JSON 직렬화/역직렬화는 모듈 접근사로 사용 *)

(* 사람 정보를 나타내는 레코드 타입 *)
type t = { name: string; age: int }

(* Person -> Yojson.Safe.t 직렬화 *)
let yojson_of_t (t : t) : Yojson.Safe.t =
  `Assoc [("name", `String t.name); ("age", `Int t.age)]

(* Yojson.Safe.t -> Person 역직렬화 (형식 오류 시 [Failure] 예외) *)
let t_of_yojson (yojson : Yojson.Safe.t) : t =
  match yojson with
  | `Assoc [("name", `String name); ("age", `Int age)] -> { name; age }
  | _ -> failwith "invalid person json"
