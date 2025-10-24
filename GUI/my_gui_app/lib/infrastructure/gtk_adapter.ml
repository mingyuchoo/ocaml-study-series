(** Infrastructure - GTK 구현 어댑터 *)

(** GTK 위젯 컨테이너 *)
type widgets =
  { window: GWindow.window;
    entry: GEdit.entry;
    label: GMisc.label;
    button: GButton.button
  }

(** GTK 초기화 *)
let init_gtk () = GMain.init ()

(** 메인 루프 실행 *)
let run_main_loop () = GMain.main ()

(** 애플리케이션 종료 *)
let quit () = GMain.quit ()

(** 라벨 텍스트 업데이트 *)
let update_label_text label text = label#set_text text

(** 엔트리 텍스트 가져오기 *)
let get_entry_text entry = entry#text
