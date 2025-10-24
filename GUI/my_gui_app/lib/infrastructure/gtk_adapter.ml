(** Infrastructure - GTK 구현 어댑터 *)

(** GTK 위젯 컨테이너 *)
type widgets =
  { window: GWindow.window;
    name_entry: GEdit.entry;
    phone_entry: GEdit.entry;
    email_entry: GEdit.entry;
    address_entry: GEdit.entry;
    search_entry: GEdit.entry;
    contact_list: GTree.view;
    list_store: GTree.list_store;
    id_col: int GTree.column;
    name_col: string GTree.column;
    phone_col: string GTree.column;
    email_col: string GTree.column;
    add_button: GButton.button;
    update_button: GButton.button;
    delete_button: GButton.button;
    clear_button: GButton.button
  }

(** GTK 초기화 *)
let init_gtk () = GMain.init ()

(** 메인 루프 실행 *)
let run_main_loop () = GMain.main ()

(** 애플리케이션 종료 *)
let quit () = GMain.quit ()

(** 엔트리 텍스트 가져오기 *)
let get_entry_text entry = entry#text

(** 엔트리 텍스트 설정 *)
let set_entry_text entry text = entry#set_text text

(** 리스트 스토어 초기화 *)
let clear_list_store store = store#clear ()

(** 연락처를 리스트에 추가 *)
let add_contact_to_list widgets contact =
  let row = widgets.list_store#append () in
  match contact.Domain.Types.id with
  | Some id ->
      widgets.list_store#set ~row ~column:widgets.id_col id;
      widgets.list_store#set ~row ~column:widgets.name_col
        contact.Domain.Types.name;
      widgets.list_store#set ~row ~column:widgets.phone_col
        contact.Domain.Types.phone;
      widgets.list_store#set ~row ~column:widgets.email_col
        contact.Domain.Types.email
  | None -> ()
