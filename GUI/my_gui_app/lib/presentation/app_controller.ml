(** Presentation - 애플리케이션 컨트롤러 *)

open Infrastructure.Gtk_adapter
open Infrastructure.Sqlite_adapter

(** 데이터베이스 참조 *)
let db_ref = ref None

(** 연락처 리스트 UI 업데이트 *)
let refresh_contact_list widgets state =
  clear_list_store widgets.list_store;
  let filtered = Application.Use_cases.filter_contacts state in
  List.iter (fun contact -> add_contact_to_list widgets contact) filtered

(** 폼 필드 업데이트 *)
let update_form_fields widgets state =
  set_entry_text widgets.name_entry state.Domain.Types.name_input;
  set_entry_text widgets.phone_entry state.Domain.Types.phone_input;
  set_entry_text widgets.email_entry state.Domain.Types.email_input;
  set_entry_text widgets.address_entry state.Domain.Types.address_input

(** 애플리케이션 상태를 UI에 반영 *)
let sync_ui_with_state widgets state =
  refresh_contact_list widgets state;
  update_form_fields widgets state

(** 데이터베이스에서 연락처 로드 *)
let load_contacts _db state_ref =
  match !db_ref with
  | Some db ->
      let contacts = get_all_contacts db in
      state_ref := Application.Use_cases.update_contacts !state_ref contacts
  | None -> ()

(** 이벤트 핸들러 설정 *)
let setup_event_handlers widgets state_ref =
  (* 윈도우 닫기 *)
  widgets.window#connect#destroy ~callback:(fun () ->
      ( match !db_ref with
      | Some db -> close_db db
      | None -> () );
      quit () )
  |> ignore;
  (* 검색 입력 *)
  widgets.search_entry#connect#changed ~callback:(fun () ->
      let query = get_entry_text widgets.search_entry in
      state_ref :=
        Application.Use_cases.handle_event !state_ref
          (Domain.Events.SearchChanged query);
      sync_ui_with_state widgets !state_ref )
  |> ignore;
  (* 추가 버튼 *)
  widgets.add_button#connect#clicked ~callback:(fun () ->
      match !db_ref with
      | Some db ->
          let contact =
            { Domain.Types.id= None;
              name= get_entry_text widgets.name_entry;
              phone= get_entry_text widgets.phone_entry;
              email= get_entry_text widgets.email_entry;
              address= get_entry_text widgets.address_entry
            }
          in
          if add_contact db contact then (
            load_contacts db state_ref;
            state_ref := Application.Use_cases.clear_form !state_ref;
            sync_ui_with_state widgets !state_ref )
      | None -> () )
  |> ignore;
  (* 수정 버튼 *)
  widgets.update_button#connect#clicked ~callback:(fun () ->
      match (!db_ref, !state_ref.Domain.Types.selected_contact) with
      | Some db, Some selected ->
          let contact =
            { selected with
              name= get_entry_text widgets.name_entry;
              phone= get_entry_text widgets.phone_entry;
              email= get_entry_text widgets.email_entry;
              address= get_entry_text widgets.address_entry
            }
          in
          if update_contact db contact then (
            load_contacts db state_ref;
            state_ref := Application.Use_cases.clear_form !state_ref;
            sync_ui_with_state widgets !state_ref )
      | _ -> () )
  |> ignore;
  (* 삭제 버튼 *)
  widgets.delete_button#connect#clicked ~callback:(fun () ->
      match (!db_ref, !state_ref.Domain.Types.selected_contact) with
      | Some db, Some contact -> (
        match contact.id with
        | Some id ->
            if delete_contact db id then (
              load_contacts db state_ref;
              state_ref := Application.Use_cases.clear_form !state_ref;
              sync_ui_with_state widgets !state_ref )
        | None -> () )
      | _ -> () )
  |> ignore;
  (* 초기화 버튼 *)
  widgets.clear_button#connect#clicked ~callback:(fun () ->
      state_ref := Application.Use_cases.clear_form !state_ref;
      sync_ui_with_state widgets !state_ref )
  |> ignore;
  (* 연락처 선택 *)
  widgets.contact_list#selection#connect#changed ~callback:(fun () ->
      match widgets.contact_list#selection#get_selected_rows with
      | path :: _ ->
          let row = widgets.list_store#get_iter path in
          let id = widgets.list_store#get ~row ~column:widgets.id_col in
          state_ref := Application.Use_cases.select_contact !state_ref id;
          sync_ui_with_state widgets !state_ref
      | [] -> () )
  |> ignore

(** 애플리케이션 실행 *)
let run () =
  let _ = init_gtk () in
  (* 데이터베이스 초기화 *)
  let db = init_db "contacts.db" in
  db_ref := Some db;
  (* 초기 상태 *)
  let state_ref = ref Domain.Types.initial_state in
  load_contacts db state_ref;
  (* UI 생성 *)
  let window = Window_builder.create_window "Address Book" in
  let widgets = Window_builder.create_widgets window in
  (* 이벤트 핸들러 설정 *)
  setup_event_handlers widgets state_ref;
  (* 초기 UI 동기화 *)
  sync_ui_with_state widgets !state_ref;
  (* 윈도우 표시 및 메인 루프 *)
  widgets.window#show ();
  run_main_loop ()
