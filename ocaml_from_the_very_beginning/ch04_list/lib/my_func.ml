let is_nil = function
  | [] -> true
  | _ -> false

let rec length = function
  | [] -> 0
  | _ :: t -> 1 + length t

let rec sum = function
  | [] -> 0
  | h :: t -> h + sum t

let length_inner xs =
  (* auxiliary function; 보조함수 *)
  let rec aux acc = function
    | [] -> acc
    | _ :: t -> aux (acc + 1) t
  in
  aux 0 xs

let rec odd_elements xs =
  match xs with
  | [] -> []
  | [h] -> [h]
  | h :: _ :: t -> h :: odd_elements t

let rec append x1 x2 =
  match x1 with
  | [] -> x2
  | h :: t -> h :: append t x2

let rec reverse xs =
  match xs with
  | [] -> []
  | h :: t -> reverse t @ [h]

let rec take n = function
  | _ when n <= 0 -> []
  | [] -> []
  | h :: t -> h :: take (n - 1) t

let rec drop n xs =
  match xs with
  | _ when n <= 0 -> xs
  | [] -> []
  | _ :: t -> drop (n - 1) t
