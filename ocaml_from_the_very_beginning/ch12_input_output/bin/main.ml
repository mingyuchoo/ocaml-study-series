open Lib

let () =
  Core.print_dict_entry (1, "Hello");
  Core.print_dict [(1, "foo"); (2, "bar"); (3, "baz")]
