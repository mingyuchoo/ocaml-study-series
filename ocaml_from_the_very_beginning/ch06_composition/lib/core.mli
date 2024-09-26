(** [add x y] returns the result of x + y. *)
val add : int -> int -> int

(** [sub x y] returns the result of x - y. *)
val sub : int -> int -> int

val length : 'a list -> int

val take : int -> 'a list -> 'a list

val drop : int -> 'a list -> 'a list

val double : int list -> int list

val map : ('a -> 'b) -> 'a list -> 'b list

val halve : int -> int

val evens : int list -> bool list

val greater : 'a -> 'a -> bool

val merge : ('a -> 'a -> bool) -> 'a list -> 'a list -> 'a list

val msort : ('a -> 'a -> bool) -> 'a list -> 'a list
