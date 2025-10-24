(** Domain Types - 비즈니스 엔티티 *)

(** 애플리케이션 상태 *)
type app_state = { input_text: string; display_text: string }

(** 초기 상태 *)
let initial_state =
  { input_text= "Type here..."; display_text= "Waiting for input..." }
