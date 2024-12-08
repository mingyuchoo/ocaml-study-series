(* Read in Sexp from string *)
let exp1 = Sexplib.Sexp.of_string "(This (is an) (s expression))"

(* Convert back to a string to print *)
let () = Printf.printf "%s\n" (Sexplib.Sexp.to_string exp1)

(* Do something *)
let () = print_endline Hello_02.En.(string_of_string_list v)
