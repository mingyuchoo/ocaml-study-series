open Ch04_list

let () = [] |> My_func.is_nil |> string_of_bool |> print_endline

let () = [1; 2; 3; 4; 5] |> My_func.length |> string_of_int |> print_endline

let () = [1; 2; 3; 4; 5] |> My_func.sum |> string_of_int |> print_endline
