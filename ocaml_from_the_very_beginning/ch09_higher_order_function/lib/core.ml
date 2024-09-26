open List

let add1 x y = x + y

let add2 x y = x + y

let rec mapl1 f l =
  match l with
  | [] -> []
  | h :: t -> map f h :: mapl1 f t

let mapl2 f l = map (map f) l

let mapl3 f = map (map f)
