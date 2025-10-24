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
let create_window title = GWindow.window ~title ~border_width:10 ()

(** UI 컴포넌트 생성 *)
let create_widgets window initial_state =
  let vbox = GPack.vbox ~packing:window#add () in
  (* 메뉴 바 *)
  create_menu_bar ~packing:vbox#pack quit;
  (* 입력 필드 *)
  let entry =
    GEdit.entry ~text:initial_state.Domain.Types.input_text
      ~packing:vbox#pack ()
  in
  (* 표시 라벨 *)
  let label =
    GMisc.label ~text:initial_state.Domain.Types.display_text
      ~packing:vbox#pack ()
  in
  (* 제출 버튼 *)
  let button = GButton.button ~label:"Submit" ~packing:vbox#pack () in
  { window; entry; label; button }
