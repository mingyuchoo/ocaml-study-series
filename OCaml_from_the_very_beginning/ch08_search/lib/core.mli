val p : int * int

val q : int * char

val fst : 'a * 'b -> 'a

val snd : 'a * 'b -> 'b

val census : (int * int) list

val y : int * int list

val lookup : 'a -> ('a * 'b) list -> 'b

val add : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list

val remove : 'a -> ('a * 'b) list -> ('a * 'b) list

val key_exists : 'a -> ('a * 'b) list -> bool
