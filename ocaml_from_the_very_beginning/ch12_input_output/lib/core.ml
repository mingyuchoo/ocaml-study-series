let print_dict_entry (k, v) =
  print_int k; print_newline (); print_string v; print_newline ()

let rec print_dict d =
  match d with
  | [] -> ()
  | h :: t -> print_dict_entry h; print_dict t

let rec iter' f l =
  match l with
  | [] -> ()
  | h :: t -> f h; iter' f t

let rec read_dict () =
  let i = read_int () in
  if i = 0 then []
  else
    let name = read_line () in
    (i, name) :: read_dict ()

let entry_to_channel ch (k, v) =
  output_string ch (string_of_int k);
  output_char ch '\n';
  output_string ch v;
  output_char ch '\n'

let dictionary_to_channel ch d = iter' (entry_to_channel ch) d

let dictionary_to_file filename dict =
  let ch = open_out filename in
  dictionary_to_channel ch dict;
  close_out ch

let entry_of_channel ch =
  let number = input_line ch in
  let name = input_line ch in
  (int_of_string number, name)

let rec dictionary_of_channel ch =
  try
    let e = entry_of_channel ch in
    e :: dictionary_of_channel ch
  with End_of_file -> []

let dictionary_of_file filename =
  let ch = open_in filename in
  let dict = dictionary_of_channel ch in
  close_in ch; dict
