let rec factorial a =
  match a with
    1 -> 1
  | _ -> a * factorial (a - 1) in
let () = print_int(factorial 4) in
print_newline ()
;;

let isvowel c =
  match c with
  'a' | 'e' | 'i' | 'o' | 'u' -> true
      | _ -> false in
print_endline(if isvowel 'a' = true then "true" else "false")
;;

let rec gcd a b =
  match b with
    0 -> a
  | _ -> gcd b (a mod b) in
print_int(gcd 100 10)
;;
