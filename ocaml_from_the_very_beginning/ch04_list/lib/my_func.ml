(*
 * let is_nil l = 
 *   match l with
 *   | [] -> true
 *   | _ -> false
 * in
 * Printf.print_endline (if is_nil [] then "true" else "false");;
 * 
 *)
let is_nil = function
  | [] -> true
  | _ -> false

(*
 * let rec length l =
 *   match l with
 *   | [] -> 0
 *   | _ :: t -> 1 + length t
 * in
 * let () = print_int (length [1;2;3;4;5;]) in
 * print_newline ()
 * ;;
 *
 *)

let rec length = function
  | [] -> 0
  | _ :: tail -> 1 + length tail

(*
 * let rec sum l =
 *   match l with
 *   | [] -> 0
 *   | h :: t -> h + sum t
 * in
 * let () = print_int (sum [1;2;3;4;5;]) in
 * print_newline ()
 * ;;
 *
 *)
let rec sum = function
  | [] -> 0
  | head :: tail -> head + sum tail

(*
 * let rec length_inner l n =
 *   match l with
 *   | [] -> n
 *   | _ :: t -> length_inner t (n + 1)
 * ;;
 *
 * let length l = length_inner l 0 in
 * let () = print_int (length [1; 2; 3; 4; 5]) in
 * print_newline ()
 *
 *)

let length_inner list =
  (* auxiliary function; 보조함수 *)
  let rec aux acc = function
    | [] -> acc
    | _ :: tail -> aux (acc + 1) tail
  in
  aux 0 list

(*
 * let rec odd_elements l =
 *   match l with
 *   | [] -> []
 *   | [a] -> [a]
 *   | a :: _ :: t -> a :: odd_elements t
 * ;;
 *
 * let () = List.iter (printf "%d ") (odd_elements [1; 2; 3; 4; 5]) in
 * print_newline ()
 *)

let rec odd_elements list =
  match list with
  | [] -> []
  | [head] -> [head]
  | head :: _ :: tail -> head :: odd_elements tail

(*
 * let rec append a b =
 *   match a with
 *   | [] -> b
 *   | h :: t -> h :: append t b
 * ;;
 * 
 *)

let rec append x1 x2 =
  match x1 with
  | [] -> x2
  | head :: tail -> head :: append tail x2

(*
 * let () = List.iter (printf "%d ") (append [1; 2; 3; 4; 5] [6; 7; 8; 9]) in
 * print_newline ()
 * 
 * let rec rev l =
 *   match l with
 *   | [] -> []
 *   | h :: t -> rev t @ [h]
 * ;;
 * 
 *)

(*
 * let () = List.iter (printf "%d ") (rev [1; 2; 3; 4; 5]) in
 * print_newline ()
 * 
 * let rec take n l =
 *   if n = 0 then []
 *   else
 *     match l with
 *     | [] -> []
 *     | h :: t -> h :: take (n - 1) t
 * ;;
 * 
 *)

(*
 * let () = List.iter (printf "%d ") (take 2 [2; 4; 6; 8; 10]) in
 * print_newline ()
 * 
 * let rec drop n l =
 *   if n = 0 then l
 *   else
 *     match l with
 *     | [] -> []
 *     | _ :: t -> drop (n - 1) t
 * ;;
 * 
 *)

(*
 * let () = List.iter (printf "%d ") (drop 2 [2; 4; 6; 8; 10]) in
 * print_newline ()
 * 
 *)
