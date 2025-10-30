(* Completion Provider for Korean Language Server *)

open Symbol_table
open Manager

(* Korean language keywords *)
let korean_keywords = ["함수"; "변수"; "만약"; "그렇지않으면"; "반복"; "반환"; "참"; "거짓"]

(* Built-in functions *)
let builtin_functions =
  [ ("출력", "화면에 텍스트를 출력합니다");
    ("입력", "사용자로부터 입력을 받습니다");
    ("길이", "문자열이나 배열의 길이를 반환합니다");
    ("변환", "값을 다른 타입으로 변환합니다") ]

(* Create a completion item from a symbol *)
let symbol_to_completion_item symbol =
  let kind =
    match symbol.kind with
    | Variable -> Some Types.Variable
    | Function -> Some Types.Function
    | Parameter -> Some Types.Variable
  in
  let detail =
    match symbol.type_ with
    | Some t -> Some t
    | None -> None
  in
  { Types.label= symbol.name;
    kind;
    detail;
    documentation= None;
    insert_text= Some symbol.name
  }

(* Create a completion item for a keyword *)
let keyword_to_completion_item keyword =
  { Types.label= keyword;
    kind= Some Types.Keyword;
    detail= Some "키워드";
    documentation= None;
    insert_text= Some keyword
  }

(* Create a completion item for a built-in function *)
let builtin_to_completion_item (name, doc) =
  { Types.label= name;
    kind= Some Types.Function;
    detail= Some "내장 함수";
    documentation= Some doc;
    insert_text= Some (name ^ "()")
  }

(* Get the word at the current position from the document *)
let get_word_at_position (doc : document) (pos : Types.position) =
  if pos.line < 0 || pos.line >= Array.length doc.lines then ""
  else
    let line = doc.lines.(pos.line) in
    let len = String.length line in
    if pos.character < 0 || pos.character > len then ""
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
      if start_pos >= end_pos then ""
      else String.sub line start_pos (end_pos - start_pos)

(* Filter completion items based on the prefix *)
let filter_by_prefix prefix items =
  if prefix = "" then items
  else
    List.filter
      (fun (item : Types.completion_item) ->
        let label_lower = String.lowercase_ascii item.Types.label in
        let prefix_lower = String.lowercase_ascii prefix in
        String.length label_lower >= String.length prefix_lower
        && String.sub label_lower 0 (String.length prefix_lower)
           = prefix_lower )
      items

(* Provide completion items for the given document and position *)
let provide_completion (doc : document) (pos : Types.position) (scope : scope)
    : Types.completion_item list =
  (* Get the word being typed *)
  let prefix = get_word_at_position doc pos in
  (* Get all symbols from the scope chain *)
  let symbols = get_all_symbols_in_chain scope in
  let symbol_items = List.map symbol_to_completion_item symbols in
  (* Add keywords *)
  let keyword_items = List.map keyword_to_completion_item korean_keywords in
  (* Add built-in functions *)
  let builtin_items =
    List.map builtin_to_completion_item builtin_functions
  in
  (* Combine all items *)
  let all_items = symbol_items @ keyword_items @ builtin_items in
  (* Filter by prefix *)
  filter_by_prefix prefix all_items

(* Create a completion list *)
let create_completion_list items = { Types.is_incomplete= false; items }
