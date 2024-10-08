open Printf

let rec length l =
  match l with
  | [] -> 0
  | _ :: t -> 1 + length t

let rec take n l =
  if n = 0 then []
  else
    match l with
    | [] -> []
    | h :: t -> h :: take (n - 1) t

let rec drop n l =
  if n = 0 then l
  else
    match l with
    | [] -> []
    | _ :: t -> drop (n - 1) t

let rec insert x l =
  match l with
  | [] -> [x]
  | h :: t -> if x <= h then x :: h :: t else h :: insert x t

let rec sort l =
  match l with
  | [] -> []
  | h :: t -> insert h (sort t)
;;

let () = List.iter (printf "%d ") (sort [5; 4; 3; 2; 1]) in
print_newline ()

let rec merge x y =
  match (x, y) with
  | [], l -> l
  | l, [] -> l
  | hx :: tx, hy :: ty ->
      if hx < hy then hx :: merge tx (hy :: ty)
      else hy :: merge (hx :: tx) ty

let rec msort l =
  match l with
  | [] -> []
  | [x] -> [x]
  | _ ->
      let left = take (length l / 2) l in
      let right = drop (length l / 2) l in
      merge (msort left) (msort right)
;;

let () = List.iter (printf "%d ") (msort [5; 4; 3; 2; 1]) in
print_newline ()
