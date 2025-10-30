(* Hover Provider for Korean Language Server *)

open Symbol_table
open Manager
open Ast

(* Format symbol kind as Korean text *)
let format_symbol_kind kind =
  match kind with
  | Variable -> "변수"
  | Function -> "함수"
  | Parameter -> "매개변수"

(* Format symbol information as markdown *)
let format_symbol_info symbol =
  let kind_str = format_symbol_kind symbol.kind in
  let type_str =
    match symbol.type_ with
    | Some t -> Printf.sprintf " : %s" t
    | None -> ""
  in
  let header =
    Printf.sprintf "**%s** `%s`%s" kind_str symbol.name type_str
  in
  let location =
    Printf.sprintf "\n\n정의 위치: 줄 %d, 열 %d"
      (symbol.definition_range.start.line + 1)
      (symbol.definition_range.start.character + 1)
  in
  header ^ location

(* Convert AST range to Types range *)
let ast_range_to_types_range (r : range) : Types.range =
  { Types.start= { Types.line= r.start.line; character= r.start.character };
    end_= { Types.line= r.end_.line; character= r.end_.character }
  }

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
        let word_range =
          { Types.start= { Types.line= pos.line; character= start_pos };
            end_= { Types.line= pos.line; character= end_pos }
          }
        in
        Some (word, word_range)

(* Built-in function documentation *)
let builtin_docs =
  [ ("출력", "화면에 텍스트를 출력합니다.\n\n사용법: `출력(메시지)`");
    ("입력", "사용자로부터 입력을 받습니다.\n\n사용법: `입력(프롬프트)`");
    ("길이", "문자열이나 배열의 길이를 반환합니다.\n\n사용법: `길이(값)`");
    ("변환", "값을 다른 타입으로 변환합니다.\n\n사용법: `변환(값, 타입)`") ]

(* Get documentation for built-in functions *)
let get_builtin_doc name = List.assoc_opt name builtin_docs

(* Korean keywords documentation *)
let keyword_docs =
  [ ("함수", "함수를 정의합니다.\n\n사용법: `함수 이름(매개변수) { ... }`");
    ("변수", "변수를 선언합니다.\n\n사용법: `변수 이름 = 값`");
    ("만약", "조건문을 작성합니다.\n\n사용법: `만약 (조건) { ... }`");
    ("그렇지않으면", "조건문의 else 절입니다.\n\n사용법: `그렇지않으면 { ... }`");
    ("반복", "반복문을 작성합니다.\n\n사용법: `반복 (조건) { ... }`");
    ("반환", "함수에서 값을 반환합니다.\n\n사용법: `반환 값`");
    ("참", "불리언 참 값");
    ("거짓", "불리언 거짓 값") ]

(* Get documentation for keywords *)
let get_keyword_doc name = List.assoc_opt name keyword_docs

(* Provide hover information for the given document and position *)
let provide_hover (doc : document) (pos : Types.position) (scope : scope) :
    Types.hover option =
  match get_word_at_position doc pos with
  | None -> None
  | Some (word, word_range) -> (
    (* First, check if it's a symbol in the scope *)
    match lookup scope word with
    | Some symbol ->
        let markdown = format_symbol_info symbol in
        Some
          { Types.contents= { kind= "markdown"; value= markdown };
            range= Some word_range
          }
    | None -> (
      (* Check if it's a built-in function *)
      match get_builtin_doc word with
      | Some doc ->
          let markdown = Printf.sprintf "**내장 함수** `%s`\n\n%s" word doc in
          Some
            { Types.contents= { kind= "markdown"; value= markdown };
              range= Some word_range
            }
      | None -> (
        (* Check if it's a keyword *)
        match get_keyword_doc word with
        | Some doc ->
            let markdown = Printf.sprintf "**키워드** `%s`\n\n%s" word doc in
            Some
              { Types.contents= { kind= "markdown"; value= markdown };
                range= Some word_range
              }
        | None -> None ) ) )
