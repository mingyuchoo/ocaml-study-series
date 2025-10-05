(** 도메인 엔티티: Person *)

(** 사람 정보를 나타내는 레코드 타입 *)
type t = { name: string; age: int }

(** Person -> Yojson.Safe.t 직렬화 *)
val yojson_of_t : t -> Yojson.Safe.t

(** Yojson.Safe.t -> Person 역직렬화 (형식 오류 시 [Failure] 예외) *)
val t_of_yojson : Yojson.Safe.t -> t
