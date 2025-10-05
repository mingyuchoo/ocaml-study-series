(* Person 직렬화/역직렬화 테스트 *)

let test_person_roundtrip () =
  let p = Opium_demo_01.Person.{ name= "alice"; age= 30 } in
  let json = Opium_demo_01.Person.yojson_of_t p in
  let p' = Opium_demo_01.Person.t_of_yojson json in
  Alcotest.(check string) "name" p.name p'.name;
  Alcotest.(check int) "age" p.age p'.age

let test_invalid_json () =
  let json = `Assoc [("name", `String "bob") (* age 누락 *)] in
  Alcotest.check_raises "invalid person json" (Failure "invalid person json")
    (fun () -> ignore (Opium_demo_01.Person.t_of_yojson json) )

let () =
  let open Alcotest in
  run "opium_demo_01"
    [ ( "person",
        [ test_case "roundtrip" `Quick test_person_roundtrip;
          test_case "invalid-json" `Quick test_invalid_json ] ) ]
