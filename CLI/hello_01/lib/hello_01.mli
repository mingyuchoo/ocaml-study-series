(** Hello_01 라이브러리의 공개 API *)

(** 프로그램에서 출력할 메시지 *)
val message : string

(** 콘솔에 [message]를 출력한다. *)
val run : unit -> unit
