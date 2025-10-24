(** Clean Architecture 테스트 - Address Book *)

open My_gui_app

(* Domain 레이어 테스트 *)
let test_initial_state () =
  let state = Domain.Types.initial_state in
  assert (state.contacts = []);
  assert (state.selected_contact = None);
  assert (state.name_input = "");
  print_endline "✓ Domain: initial_state test passed"

let test_empty_contact () =
  let contact = Domain.Types.empty_contact in
  assert (contact.id = None);
  assert (contact.name = "");
  print_endline "✓ Domain: empty_contact test passed"

(* Application 레이어 테스트 *)
let test_update_name () =
  let state = Domain.Types.initial_state in
  let new_state = Application.Use_cases.update_name state "John Doe" in
  assert (new_state.name_input = "John Doe");
  print_endline "✓ Application: update_name test passed"

let test_update_phone () =
  let state = Domain.Types.initial_state in
  let new_state = Application.Use_cases.update_phone state "123-456-7890" in
  assert (new_state.phone_input = "123-456-7890");
  print_endline "✓ Application: update_phone test passed"

let test_clear_form () =
  let state =
    { Domain.Types.initial_state with
      name_input= "Test";
      phone_input= "123";
      selected_contact= Some Domain.Types.empty_contact
    }
  in
  let new_state = Application.Use_cases.clear_form state in
  assert (new_state.name_input = "");
  assert (new_state.phone_input = "");
  assert (new_state.selected_contact = None);
  print_endline "✓ Application: clear_form test passed"

let test_filter_contacts () =
  let contact1 =
    { Domain.Types.empty_contact with
      id= Some 1;
      name= "John Doe";
      phone= "123";
      email= "john@test.com"
    }
  in
  let contact2 =
    { Domain.Types.empty_contact with
      id= Some 2;
      name= "Jane Smith";
      phone= "456";
      email= "jane@test.com"
    }
  in
  let state =
    { Domain.Types.initial_state with
      contacts= [contact1; contact2];
      search_query= "john"
    }
  in
  let filtered = Application.Use_cases.filter_contacts state in
  assert (List.length filtered = 1);
  assert ((List.hd filtered).name = "John Doe");
  print_endline "✓ Application: filter_contacts test passed"

let test_handle_event () =
  let state = Domain.Types.initial_state in
  let new_state =
    Application.Use_cases.handle_event state
      (Domain.Events.NameChanged "Alice")
  in
  assert (new_state.name_input = "Alice");
  print_endline "✓ Application: handle_event test passed"

(* 모든 테스트 실행 *)
let () =
  print_endline "\n=== Clean Architecture Tests - Address Book ===\n";
  test_initial_state ();
  test_empty_contact ();
  test_update_name ();
  test_update_phone ();
  test_clear_form ();
  test_filter_contacts ();
  test_handle_event ();
  print_endline "\n✓ All tests passed!\n"
