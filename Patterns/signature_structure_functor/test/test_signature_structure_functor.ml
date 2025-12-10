open Signature_structure_functor.Lib

let test_empty_set () =
  let s = IntSet.empty in
  assert (not (IntSet.is_member s 1));
  Printf.printf "✓ 빈 집합 테스트 통과\n"

let test_insert_and_member () =
  let s = IntSet.empty in
  let s = IntSet.insert s 5 in
  let s = IntSet.insert s 10 in
  assert (IntSet.is_member s 5);
  assert (IntSet.is_member s 10);
  assert (not (IntSet.is_member s 3));
  Printf.printf "✓ 삽입 및 멤버십 테스트 통과\n"

let test_duplicate_insert () =
  let s = IntSet.empty in
  let s = IntSet.insert s 5 in
  let s_before = IntSet.to_list s in
  let s = IntSet.insert s 5 in
  (* 중복 삽입 *)
  let s_after = IntSet.to_list s in
  assert (List.length s_before = List.length s_after);
  Printf.printf "✓ 중복 삽입 테스트 통과\n"

let () =
  Printf.printf "=== IntSet 테스트 시작 ===\n";
  test_empty_set ();
  test_insert_and_member ();
  test_duplicate_insert ();
  Printf.printf "=== 모든 테스트 통과! ===\n"
