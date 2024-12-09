open Ch04_list

let () =
  []
  |> My_func.is_nil
  |> string_of_bool
  |> ( ^ ) "My_func.is_nil result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5]
  |> My_func.length
  |> string_of_int
  |> ( ^ ) "My_func.length result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5]
  |> My_func.sum
  |> string_of_int
  |> ( ^ ) "My_func.sum function result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5]
  |> My_func.length_inner
  |> string_of_int
  |> ( ^ ) "My_func.length_inner function result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5]
  |> My_func.odd_elements
  |> List.map string_of_int
  |> String.concat " "
  |> ( ^ ) "My_func.odd_elements function result: "
  |> print_endline

let () =
  [1; 2; 3]
  |> My_func.append [4; 5; 6]
  |> List.map string_of_int
  |> String.concat " "
  |> ( ^ ) "My_func.append function result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5; 6; 7; 8; 9]
  |> My_func.reverse
  |> List.map string_of_int
  |> String.concat " "
  |> ( ^ ) "My_func.reverse function result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5; 6; 7; 8; 9]
  |> My_func.take 4
  |> List.map string_of_int
  |> String.concat " "
  |> ( ^ ) "My_func.take function result: "
  |> print_endline

let () =
  [1; 2; 3; 4; 5; 6; 7; 8; 9]
  |> My_func.drop 4
  |> List.map string_of_int
  |> String.concat " "
  |> ( ^ ) "My_func.drop function result: "
  |> print_endline
