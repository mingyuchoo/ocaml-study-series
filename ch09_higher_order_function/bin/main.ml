open Lib

let () =
  let result = Help.add1 2 3 in
  print_endline (string_of_int result);

  let result = Help.add2 2 3 in
  print_int(result);
