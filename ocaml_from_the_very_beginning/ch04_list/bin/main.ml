open Printf

let () = print_endline "Hello, World!";;

let isnil l =
  match l with
  | [] -> true
  | _ -> false
in
print_endline (if isnil [] then "true" else "false")
;;

let rec length l =
  match l with
  | [] -> 0
  | _ :: t -> 1 + length t
in
let () = print_int (length [1; 2; 3; 4; 5]) in
print_newline ()
;;

let rec sum l =
  match l with
  | [] -> 0
  | h :: t -> h + sum t
in
let () = print_int (sum [1; 2; 3; 4; 5]) in
print_newline ()

let rec length_inner l n =
  match l with
  | [] -> n
  | _ :: t -> length_inner t (n + 1)
;;

let length l = length_inner l 0 in
let () = print_int (length [1; 2; 3; 4; 5]) in
print_newline ()

let rec odd_elements l =
  match l with
  | [] -> []
  | [a] -> [a]
  | a :: _ :: t -> a :: odd_elements t
;;

let () = List.iter (printf "%d ") (odd_elements [1; 2; 3; 4; 5]) in
print_newline ()

let rec append a b =
  match a with
  | [] -> b
  | h :: t -> h :: append t b
;;

let () = List.iter (printf "%d ") (append [1; 2; 3; 4; 5] [6; 7; 8; 9]) in
print_newline ()

let rec rev l =
  match l with
  | [] -> []
  | h :: t -> rev t @ [h]
;;

let () = List.iter (printf "%d ") (rev [1; 2; 3; 4; 5]) in
print_newline ()

let rec take n l =
  if n = 0 then []
  else
    match l with
    | [] -> []
    | h :: t -> h :: take (n - 1) t
;;

let () = List.iter (printf "%d ") (take 2 [2; 4; 6; 8; 10]) in
print_newline ()

let rec drop n l =
  if n = 0 then l
  else
    match l with
    | [] -> []
    | _ :: t -> drop (n - 1) t
;;

let () = List.iter (printf "%d ") (drop 2 [2; 4; 6; 8; 10]) in
print_newline ()
