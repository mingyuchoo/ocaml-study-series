(* 간단한 종료코드 기반 테스트 *)

let () =
  (* Hello_01.message가 예상 문자열인지 확인한다. *)
  let expected = "Hello, World!" in
  if Hello_01.message <> expected then (
    Printf.eprintf "[FAIL] expected=%S actual=%S\n" expected Hello_01.message;
    exit 1 );
  (* 추가로 run ()이 예외 없이 실행되는지만 확인한다. *)
  ( try Hello_01.run ()
    with _ ->
      prerr_endline "[FAIL] run () raised an exception";
      exit 1 );
  print_endline "[OK] all tests passed"
