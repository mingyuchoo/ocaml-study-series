open Lib

let () =
  try
    begin
      match Sys.argv with
      | [|_; filename|] ->
        let stats = Core.stats_from_file filename in
        print_string "Words: ";
        print_int (Core.words stats);
        print_newline ();
        print_string "Characters: ";
        print_int (Core.characters stats);
        print_newline ();
        print_string "Sentences: ";
        print_int (Core.sentences stats);
        print_newline ();
        print_string "Lines ";
        print_int (Core.lines stats);
        print_newline ()

      | _ ->
        print_string "Usage: stats <filename>";
        print_newline ()
    end
  with
    e ->
    print_string "An error occurred: ";
    print_string (Printexc.to_string e);
    print_newline ();
    exit 1
