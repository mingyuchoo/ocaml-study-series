(* 애플리케이션 실행 진입점 구현 - 라이브러리에서 실행 로직을 관리 *)
let run () =
  (* 문자열에서 S-식 파싱 *)
  let exp1 = Sexplib.Sexp.of_string "(This (is an) (s expression))" in
  (* 다시 문자열로 변환하여 출력 *)
  Printf.printf "%s\n" (Sexplib.Sexp.to_string exp1);
  (* 라이브러리 모듈 사용 예시 *)
  print_endline En.(string_of_string_list v)
