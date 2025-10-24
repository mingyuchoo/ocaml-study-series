let () =
  let _ = GMain.init () in
  let window = GWindow.window ~title:"OCaml GTK App" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.quit |> ignore;
  (* 메뉴 바 *)
  let vbox = GPack.vbox ~packing:window#add () in
  let menubar = GMenu.menu_bar ~packing:vbox#pack () in
  let file_menu = GMenu.menu () in
  let file_item = GMenu.menu_item ~label:"File" ~packing:menubar#append () in
  file_item#set_submenu file_menu;
  let quit_item =
    GMenu.menu_item ~label:"Quit" ~packing:file_menu#append ()
  in
  quit_item#connect#activate ~callback:GMain.quit |> ignore;
  (* 입력창과 버튼 *)
  let entry = GEdit.entry ~text:"Type here..." ~packing:vbox#pack () in
  let label =
    GMisc.label ~text:"Waiting for input..." ~packing:vbox#pack ()
  in
  let button = GButton.button ~label:"Submit" ~packing:vbox#pack () in
  button#connect#clicked ~callback:(fun () ->
      label#set_text (Printf.sprintf "You typed: %s" entry#text) )
  |> ignore;
  window#show ();
  GMain.main ()
