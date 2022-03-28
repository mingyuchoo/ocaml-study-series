open Lib

(* swap *)
let () =
  let a = ref 100 in
  let b = ref 200 in
  let () = Core.swap a b in
    print_int !a;
    print_newline ();
    print_int !b;
    print_newline ()

(* begin .. end  *)
let () =
  let x = 1 in
  let y = 2 in
  let a = ref 0 in
  let b = ref 0 in
  let c = ref 0 in
  if x = y then
    begin
      a := !a + 1;
      b := !b - 1
    end
  else
    c := !c + 1;
  print_int !a;
  print_newline ();
  print_int !b;
  print_newline ();
  print_int !c;
  print_newline ()

(* for ... = ... to ... do ... done *)
let () =
  for x = 1 to 50
  do
    print_int x;
    print_newline ()
  done

