open Lib

let () =
  let result = Core.add1 2 3 in
  print_endline (string_of_int result);

  let result = Core.add2 2 3 in
  print_int(result);
