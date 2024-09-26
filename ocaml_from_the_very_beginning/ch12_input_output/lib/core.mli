val print_dict_entry : int * string -> unit

val print_dict : (int * string) list -> unit

val iter' : ('a -> unit) -> 'a list -> unit

val read_dict : unit -> (int * string) list

val entry_to_channel : out_channel -> int * string -> unit

val dictionary_to_channel : out_channel -> (int * string) list -> unit

val dictionary_to_file : string -> (int * string) list -> unit

val entry_of_channel : in_channel -> int * string

val dictionary_of_channel : in_channel -> (int * string) list

val dictionary_of_file : string -> (int * string) list
