(* 간단한 어설션 기반 테스트. 실패 시 비-제로 종료코드로 테스트 실패 처리됨. *)

let assert_equal_string ~expected ~actual =
  if String.compare expected actual <> 0 then (
    Printf.eprintf "[FAIL] expected=%S\n        actual=%S\n" expected actual;
    exit 1)

let assert_equal_int ~expected ~actual =
  if expected <> actual then (
    Printf.eprintf "[FAIL] expected=%d actual=%d\n" expected actual;
    exit 1)

let () =
  (* 1) En.v 내용과 포맷 검증 *)
  let open Hello_02.En in
  let shown = string_of_string_list v in
  let expected = "[\"hello_02\"; \"using\"; \"an\"; \"opam\"; \"library\"]" in
  assert_equal_string ~expected ~actual:shown;

  (* 2) En.v 길이 검증 *)
  assert_equal_int ~expected:5 ~actual:(List.length v);

  (* 3) Es.v 값 검증 *)
  let open Hello_02.Es in
  assert_equal_string ~expected:"¡Hola, mundo!" ~actual:v;

  (* 모두 통과 *)
  Printf.printf "All tests passed.\n"
