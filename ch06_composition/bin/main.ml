open Printf
open Lib

let () =
  let result = Math.add 2 3 in
  print_endline (string_of_int result);

  let result = Math.sub 3 1 in
  print_endline (string_of_int result);

  let () = List.iter (printf "%d ") (Math.double [1;2;3;4;5]) in
  print_newline();

  let () = List.iter (printf "%b ") (Math.evens [1;2;3;4;5]) in
  print_newline();

  let () = List.iter (printf "%d ") (Math.msort Math.greater [5;4;6;2;1]) in
  print_newline();

  let () = List.iter (printf "%d ") (Math.msort (<=) [5;4;6;2;1]) in
  print_newline();

  let () = List.iter (printf "%d ") (Math.msort (>=) [5;4;6;2;1]) in
  print_newline()
