(* Signature_structure_functor 모듈을 열어 IntSet 기능을 바로 사용할 수 있게 합니다. *)
open Signature_structure_functor.Lib

let () =
  Printf.printf "--- IntSet 모듈 테스트 시작 ---\n";
  (* 4단계에서 생성된 IntSet 모듈 사용 *)
  let s1 = IntSet.empty in
  let s2 = IntSet.insert s1 10 in
  let s3 = IntSet.insert s2 5 in
  let s4 = IntSet.insert s3 10 in
  (* 중복 삽입 무시 *)
  Printf.printf "Set 내용: [";
  List.iter (fun x -> Printf.printf "%d; " x) (IntSet.to_list s4);
  Printf.printf "]\n";
  let is_10_member = IntSet.is_member s4 10 in
  let is_7_member = IntSet.is_member s4 7 in
  Printf.printf "10 포함 여부: %B\n" is_10_member;
  Printf.printf "7 포함 여부: %B\n" is_7_member;
  Printf.printf "--- 테스트 완료 ---\n"
