type colour = Red
            | Green
            | Blue
            | Yellow
            | RGB of int * int * int

val col : colour

val cols : colour list

val colpair : char * colour

val components : colour -> int * int * int



type 'a option = None | Some of 'a

val nothing : 'a option

val number : int option

val numbers : int option list

val word : char list option

val lookup_opt : 'a -> ('a * 'b) list -> 'b option



type 'a sequence = Nil | Cons of 'a * 'a sequence


val length : 'a sequence -> int

val append : 'a sequence -> 'a sequence -> 'a sequence




type expr = Num of int
          | Add of expr * expr
          | Subtract of expr * expr
          | Multiply of expr * expr
          | Divide of expr * expr

val evaluate : expr -> int
