(*
 * let rec factorial a =
 *   match a with
 *   | 1 -> 1
 *   | _ -> a * factorial (a - 1)
 * in
 * let () = print_int (factorial 4) in
 * print_newline ()
 * ;;
 *
 *)
let rec factorial = function
  | 1 -> 1
  | n -> n * factorial (n - 1)

(*
 * let rec gcd a b =
 *   match b with
 *   | 0 -> a
 *   | _ -> gcd b (a mod b)
 * in
 * print_int (gcd 100 10)
 *
 *)
let rec gcd n m =
  match m with
  | 0 -> n
  | _ -> gcd m (n mod m)
