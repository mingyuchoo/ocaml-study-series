(** Document Manager Module
    
    Manages the state of open text documents in the language server.
    Provides functions to open, close, update, and query documents.
*)

open Types

(** Represents a text document with its content and metadata *)
type document =
  { uri: string;  (** Document URI (file:// scheme) *)
    version: int;  (** Document version number *)
    content: string;  (** Full document content *)
    lines: string array  (** Document content split into lines *)
  }

(** Document store type - maps URI to document *)
type t = (string, document) Hashtbl.t

(** Create a new empty document manager *)
let create () : t = Hashtbl.create 16

(** Split content into lines, preserving line endings *)
let split_into_lines (content : string) : string array =
  (* Split by newline characters, handling both \n and \r\n *)
  let lines = String.split_on_char '\n' content in
  Array.of_list lines

(** Open a new document and add it to the manager *)
let open_document (manager : t) ~(uri : string) ~(version : int)
    ~(content : string) : unit =
  let lines = split_into_lines content in
  let doc = { uri; version; content; lines } in
  Hashtbl.replace manager uri doc

(** Close a document and remove it from the manager *)
let close_document (manager : t) ~(uri : string) : unit =
  Hashtbl.remove manager uri

(** Update an existing document with new content *)
let update_document (manager : t) ~(uri : string) ~(version : int)
    ~(content : string) : unit =
  let lines = split_into_lines content in
  let doc = { uri; version; content; lines } in
  Hashtbl.replace manager uri doc

(** Get a document by URI *)
let get_document (manager : t) ~(uri : string) : document option =
  Hashtbl.find_opt manager uri

(** Get the content of a document *)
let get_content (manager : t) ~(uri : string) : string option =
  match get_document manager ~uri with
  | Some doc -> Some doc.content
  | None -> None

(** Get the lines of a document *)
let get_lines (manager : t) ~(uri : string) : string array option =
  match get_document manager ~uri with
  | Some doc -> Some doc.lines
  | None -> None

(** Get the version of a document *)
let get_version (manager : t) ~(uri : string) : int option =
  match get_document manager ~uri with
  | Some doc -> Some doc.version
  | None -> None

(** Check if a document is open *)
let is_open (manager : t) ~(uri : string) : bool = Hashtbl.mem manager uri

(** Get the number of open documents *)
let count (manager : t) : int = Hashtbl.length manager

(** Get all open document URIs *)
let get_all_uris (manager : t) : string list =
  Hashtbl.fold (fun uri _ acc -> uri :: acc) manager []

(** Get a specific line from a document (0-based indexing) *)
let get_line (manager : t) ~(uri : string) ~(line : int) : string option =
  match get_lines manager ~uri with
  | Some lines ->
      if line >= 0 && line < Array.length lines then Some lines.(line)
      else None
  | None -> None

(** Get the number of lines in a document *)
let get_line_count (manager : t) ~(uri : string) : int option =
  match get_lines manager ~uri with
  | Some lines -> Some (Array.length lines)
  | None -> None

(** Get text at a specific position *)
let get_text_at_position (manager : t) ~(uri : string) ~(position : position)
    : string option =
  match get_line manager ~uri ~line:position.line with
  | Some line_text ->
      if
        position.character >= 0
        && position.character < String.length line_text
      then Some (String.make 1 line_text.[position.character])
      else None
  | None -> None

(** Get text in a range *)
let get_text_in_range (manager : t) ~(uri : string) ~(range : range) :
    string option =
  match get_lines manager ~uri with
  | None -> None
  | Some lines ->
      let start_line = range.start.line in
      let end_line = range.end_.line in
      if
        start_line < 0
        || end_line >= Array.length lines
        || start_line > end_line
      then None
      else if start_line = end_line then
        (* Single line range *)
        let line = lines.(start_line) in
        let start_char = max 0 range.start.character in
        let end_char = min (String.length line) range.end_.character in
        if start_char <= end_char then
          Some (String.sub line start_char (end_char - start_char))
        else None
      else
        (* Multi-line range *)
        let buffer = Buffer.create 256 in
        (* First line *)
        let first_line = lines.(start_line) in
        let start_char = max 0 range.start.character in
        if start_char < String.length first_line then
          Buffer.add_string buffer
            (String.sub first_line start_char
               (String.length first_line - start_char) );
        Buffer.add_char buffer '\n';
        (* Middle lines *)
        for i = start_line + 1 to end_line - 1 do
          Buffer.add_string buffer lines.(i);
          Buffer.add_char buffer '\n'
        done;
        (* Last line *)
        let last_line = lines.(end_line) in
        let end_char = min (String.length last_line) range.end_.character in
        if end_char > 0 then
          Buffer.add_string buffer (String.sub last_line 0 end_char);
        Some (Buffer.contents buffer)
