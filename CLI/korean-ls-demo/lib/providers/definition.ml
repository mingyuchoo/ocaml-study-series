(* Definition Provider for Korean Language Server *)

open Symbol_table
open Manager

(* Get the word at the current position from the document *)
let get_word_at_position (doc : document) (pos : Types.position) =
  if pos.line < 0 || pos.line >= Array.length doc.lines then None
  else
    let line = doc.lines.(pos.line) in
    let len = String.length line in
    if pos.character < 0 || pos.character > len then None
    else
      (* Find the start of the word *)
      let rec find_start i =
        if i < 0 then 0
        else
          let c = line.[i] in
          if
            (c >= 'a' && c <= 'z')
            || (c >= 'A' && c <= 'Z')
            || (c >= '0' && c <= '9')
            || c = '_'
            || Char.code c > 127
            (* Korean characters *)
          then find_start (i - 1)
          else i + 1
      in
      (* Find the end of the word *)
      let rec find_end i =
        if i >= len then len
        else
          let c = line.[i] in
          if
            (c >= 'a' && c <= 'z')
            || (c >= 'A' && c <= 'Z')
            || (c >= '0' && c <= '9')
            || c = '_'
            || Char.code c > 127
            (* Korean characters *)
          then find_end (i + 1)
          else i
      in
      let start_pos = find_start (pos.character - 1) in
      let end_pos = find_end pos.character in
      if start_pos >= end_pos then None
      else
        let word = String.sub line start_pos (end_pos - start_pos) in
        Some word

(* Convert AST range to Types range *)
let ast_range_to_types_range (r : Ast.range) : Types.range =
  { Types.start= { Types.line= r.start.line; character= r.start.character };
    end_= { Types.line= r.end_.line; character= r.end_.character }
  }

(* Provide definition location for the given document and position *)
let provide_definition (doc : document) (pos : Types.position) (scope : scope)
    : Types.location option =
  match get_word_at_position doc pos with
  | None -> None
  | Some word -> (
    (* Look up the symbol in the scope chain *)
    match lookup scope word with
    | Some symbol ->
        (* Return the location of the symbol's definition *)
        let definition_range =
          ast_range_to_types_range symbol.definition_range
        in
        Some { Types.uri= doc.uri; range= definition_range }
    | None ->
        (* Symbol not found - could be a built-in or keyword *)
        None )
