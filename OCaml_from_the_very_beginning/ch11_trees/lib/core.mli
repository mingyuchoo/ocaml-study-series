type 'a tree = Br of 'a * 'a tree * 'a tree
             | Lf

val size : 'a tree -> int

val total : int tree -> int

val max : int -> int -> int

val maxdepth : 'a tree -> int

val list_of_tree : 'a tree -> 'a list

val tree_map : ('a -> 'b) -> 'a tree -> 'b tree

val lookup : ('a * 'b) tree -> 'a -> 'b option

val insert : ('a * 'b) tree -> 'a -> 'b -> ('a * 'b) tree
