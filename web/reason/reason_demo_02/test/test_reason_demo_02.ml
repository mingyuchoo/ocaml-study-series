(* Basic tests for the address book application *)

open Lib

let test_contact_creation () =
  let contact =
    Contact.create "홍길동" "hong@example.com" "010-1234-5678" "서울시"
  in
  assert (Contact.name contact = "홍길동");
  assert (Contact.email contact = "hong@example.com");
  assert (Contact.phone contact = "010-1234-5678");
  assert (Contact.address contact = "서울시");
  print_endline "✓ Contact creation test passed"

let test_contact_validation () =
  let valid_contact =
    Contact.create "홍길동" "hong@example.com" "010-1234-5678" "서울시"
  in
  ( match Contact.validate valid_contact with
  | Ok _ -> print_endline "✓ Valid contact validation passed"
  | Error _ -> failwith "Valid contact should pass validation" );
  let invalid_contact =
    Contact.create "" "hong@example.com" "010-1234-5678" "서울시"
  in
  ( match Contact.validate invalid_contact with
  | Error _ ->
      print_endline "✓ Invalid contact (empty name) validation passed"
  | Ok _ -> failwith "Invalid contact should fail validation" );
  let invalid_email =
    Contact.create "홍길동" "invalid-email" "010-1234-5678" "서울시"
  in
  match Contact.validate invalid_email with
  | Error _ -> print_endline "✓ Invalid email validation passed"
  | Ok _ -> failwith "Invalid email should fail validation"

let () =
  print_endline "\n=== Running Address Book Tests ===\n";
  test_contact_creation ();
  test_contact_validation ();
  print_endline "\n=== All tests passed! ===\n"
