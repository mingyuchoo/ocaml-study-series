(** Clean Architecture 테스트 *)

open My_gui_app

(* Domain 레이어 테스트 *)
let test_initial_state () =
  let state = Domain.Types.initial_state in
  assert (state.input_text = "Type here...");
  assert (state.display_text = "Waiting for input...");
  print_endline "✓ Domain: initial_state test passed"

(* Application 레이어 테스트 *)
let test_update_input () =
  let state = Domain.Types.initial_state in
  let new_state = Application.Use_cases.update_input state "Hello" in
  assert (new_state.input_text = "Hello");
  print_endline "✓ Application: update_input test passed"

let test_handle_submit () =
  let state = { Domain.Types.input_text= "Test"; display_text= "" } in
  let new_state = Application.Use_cases.handle_submit state in
  assert (new_state.display_text = "You typed: Test");
  print_endline "✓ Application: handle_submit test passed"

let test_handle_event () =
  let state = Domain.Types.initial_state in
  let new_state =
    Application.Use_cases.handle_event state
      (Domain.Events.InputChanged "World")
  in
  assert (new_state.input_text = "World");
  print_endline "✓ Application: handle_event test passed"

(* 모든 테스트 실행 *)
let () =
  print_endline "\n=== Clean Architecture Tests ===\n";
  test_initial_state ();
  test_update_input ();
  test_handle_submit ();
  test_handle_event ();
  print_endline "\n✓ All tests passed!\n"
