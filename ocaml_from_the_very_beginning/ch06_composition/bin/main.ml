open Printf
open Lib

let () =
  let result = Core.add 2 3 in
  print_endline (string_of_int result);
  let result = Core.sub 3 1 in
  print_endline (string_of_int result);
  let () = List.iter (printf "%d ") (Core.double [1; 2; 3; 4; 5]) in
  print_newline ();
  let () = List.iter (printf "%b ") (Core.evens [1; 2; 3; 4; 5]) in
  print_newline ();
  let () =
    List.iter (printf "%d ") (Core.msort Core.greater [5; 4; 6; 2; 1])
  in
  print_newline ();
  let () = List.iter (printf "%d ") (Core.msort ( <= ) [5; 4; 6; 2; 1]) in
  print_newline ();
  let () = List.iter (printf "%d ") (Core.msort ( >= ) [5; 4; 6; 2; 1]) in
  print_newline ()
