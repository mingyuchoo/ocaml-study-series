(** Presentation - UI 컴포넌트 빌더 *)

open Infrastructure.Gtk_adapter

(** 메뉴 바 생성 *)
let create_menu_bar ~packing on_quit =
  let menubar = GMenu.menu_bar ~packing () in
  let file_menu = GMenu.menu () in
  let file_item = GMenu.menu_item ~label:"File" ~packing:menubar#append () in
  file_item#set_submenu file_menu;
  let quit_item =
    GMenu.menu_item ~label:"Quit" ~packing:file_menu#append ()
  in
  quit_item#connect#activate ~callback:on_quit |> ignore

(** 메인 윈도우 생성 *)
let create_window title =
  let window =
    GWindow.window ~title ~border_width:10 ~width:800 ~height:600 ()
  in
  window

(** 연락처 리스트 뷰 생성 *)
let create_contact_list ~packing =
  let cols = new GTree.column_list in
  let id_col = cols#add Gobject.Data.int in
  let name_col = cols#add Gobject.Data.string in
  let phone_col = cols#add Gobject.Data.string in
  let email_col = cols#add Gobject.Data.string in
  let list_store = GTree.list_store cols in
  let view = GTree.view ~model:list_store ~packing () in
  let renderer = GTree.cell_renderer_text [] in
  let name_column =
    GTree.view_column ~title:"Name"
      ~renderer:(renderer, [("text", name_col)])
      ()
  in
  let phone_column =
    GTree.view_column ~title:"Phone"
      ~renderer:(renderer, [("text", phone_col)])
      ()
  in
  let email_column =
    GTree.view_column ~title:"Email"
      ~renderer:(renderer, [("text", email_col)])
      ()
  in
  view#append_column name_column |> ignore;
  view#append_column phone_column |> ignore;
  view#append_column email_column |> ignore;
  (view, list_store, id_col, name_col, phone_col, email_col)

(** UI 컴포넌트 생성 *)
let create_widgets window =
  (* Paned 위젯으로 좌우 분할 (크기 조절 핸들 포함) *)
  let paned = GPack.paned `HORIZONTAL ~packing:window#add () in
  (* 왼쪽: 연락처 리스트 *)
  let left_vbox =
    GPack.vbox ~spacing:5 ~border_width:5 ~packing:paned#add1 ()
  in
  GMisc.label ~text:"Search:" ~xalign:0.0 ~packing:left_vbox#pack ()
  |> ignore;
  let search_entry = GEdit.entry ~packing:left_vbox#pack () in
  let scrolled =
    GBin.scrolled_window ~hpolicy:`AUTOMATIC ~vpolicy:`AUTOMATIC
      ~packing:(left_vbox#pack ~expand:true ~fill:true)
      ()
  in
  let contact_list, list_store, id_col, name_col, phone_col, email_col =
    create_contact_list ~packing:scrolled#add
  in
  (* 오른쪽: 입력 폼 *)
  let right_vbox =
    GPack.vbox ~spacing:5 ~border_width:5 ~packing:paned#add2 ()
  in
  (* 초기 위치를 50:50으로 설정 (윈도우 너비의 절반) *)
  paned#set_position 400;
  GMisc.label ~text:"Contact Details" ~xalign:0.0 ~packing:right_vbox#pack ()
  |> ignore;
  GMisc.label ~text:"Name:" ~xalign:0.0 ~packing:right_vbox#pack () |> ignore;
  let name_entry = GEdit.entry ~packing:right_vbox#pack () in
  GMisc.label ~text:"Phone:" ~xalign:0.0 ~packing:right_vbox#pack ()
  |> ignore;
  let phone_entry = GEdit.entry ~packing:right_vbox#pack () in
  GMisc.label ~text:"Email:" ~xalign:0.0 ~packing:right_vbox#pack ()
  |> ignore;
  let email_entry = GEdit.entry ~packing:right_vbox#pack () in
  GMisc.label ~text:"Address:" ~xalign:0.0 ~packing:right_vbox#pack ()
  |> ignore;
  let address_entry = GEdit.entry ~packing:right_vbox#pack () in
  (* 버튼들 *)
  let button_hbox = GPack.hbox ~spacing:5 ~packing:right_vbox#pack () in
  let add_button =
    GButton.button ~label:"Add" ~packing:button_hbox#pack ()
  in
  let update_button =
    GButton.button ~label:"Update" ~packing:button_hbox#pack ()
  in
  let delete_button =
    GButton.button ~label:"Delete" ~packing:button_hbox#pack ()
  in
  let clear_button =
    GButton.button ~label:"Clear" ~packing:button_hbox#pack ()
  in
  { window;
    name_entry;
    phone_entry;
    email_entry;
    address_entry;
    search_entry;
    contact_list;
    list_store;
    id_col;
    name_col;
    phone_col;
    email_col;
    add_button;
    update_button;
    delete_button;
    clear_button
  }
