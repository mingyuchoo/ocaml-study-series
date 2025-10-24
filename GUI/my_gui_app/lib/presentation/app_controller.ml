(** Presentation - 애플리케이션 컨트롤러 *)

open Infrastructure.Gtk_adapter

(** 애플리케이션 상태를 UI에 반영 *)
let sync_ui_with_state widgets state =
  update_label_text widgets.label state.Domain.Types.display_text

(** 이벤트 핸들러 설정 *)
let setup_event_handlers widgets state_ref =
  (* 윈도우 닫기 *)
  widgets.window#connect#destroy ~callback:quit |> ignore;
  (* 제출 버튼 클릭 *)
  widgets.button#connect#clicked ~callback:(fun () ->
      let current_text = get_entry_text widgets.entry in
      state_ref := Application.Use_cases.update_input !state_ref current_text;
      state_ref := Application.Use_cases.handle_submit !state_ref;
      sync_ui_with_state widgets !state_ref )
  |> ignore

(** 애플리케이션 실행 *)
let run () =
  let _ = init_gtk () in
  (* 초기 상태 *)
  let state_ref = ref Domain.Types.initial_state in
  (* UI 생성 *)
  let window = Window_builder.create_window "OCaml GTK App" in
  let widgets = Window_builder.create_widgets window !state_ref in
  (* 이벤트 핸들러 설정 *)
  setup_event_handlers widgets state_ref;
  (* 윈도우 표시 및 메인 루프 *)
  widgets.window#show ();
  run_main_loop ()
