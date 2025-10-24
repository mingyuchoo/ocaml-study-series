(** Application Use Cases - 비즈니스 로직 *)

open Domain.Types

(** 입력 텍스트 업데이트 *)
let update_input state new_text = { state with input_text= new_text }

(** 제출 처리 - 입력을 표시 텍스트로 변환 *)
let handle_submit state =
  let formatted_text = Printf.sprintf "You typed: %s" state.input_text in
  { state with display_text= formatted_text }

(** 이벤트 처리 *)
let handle_event state event =
  match event with
  | Domain.Events.InputChanged text -> update_input state text
  | Domain.Events.SubmitClicked -> handle_submit state
  | Domain.Events.QuitRequested -> state
