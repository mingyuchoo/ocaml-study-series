(* DOCX to Markdown converter *)

exception Parse_error of string

(* XML 파싱 헬퍼 함수 *)
let rec skip_element input depth =
  match depth with
  | 0 -> ()
  | _ -> (
    match Xmlm.input input with
    | `El_start _ -> skip_element input (depth + 1)
    | `El_end -> skip_element input (depth - 1)
    | `Data _ -> skip_element input depth
    | `Dtd _ -> skip_element input depth )

let rec extract_text_from_element input acc =
  match Xmlm.input input with
  | `El_start _ ->
      let inner_acc = extract_text_from_element input [] in
      let new_acc = List.rev_append inner_acc acc in
      extract_text_from_element input new_acc
  | `El_end -> acc
  | `Data text -> extract_text_from_element input (text :: acc)
  | `Dtd _ -> extract_text_from_element input acc

let rec extract_paragraph_text input acc =
  match Xmlm.input input with
  | `El_start ((_, tag), _) -> (
    match tag = "r" || tag = "t" with
    | true ->
        let text_parts = extract_text_from_element input [] in
        extract_paragraph_text input (List.rev_append text_parts acc)
    | false ->
        skip_element input 1;
        extract_paragraph_text input acc )
  | `El_end -> acc
  | `Data _ -> extract_paragraph_text input acc
  | `Dtd _ -> extract_paragraph_text input acc

(* DOCX 파일에서 document.xml 추출 *)
let extract_document_xml docx_path =
  try
    let zip = Zip.open_in docx_path in
    let entry = Zip.find_entry zip "word/document.xml" in
    let content = Zip.read_entry zip entry in
    Zip.close_in zip; content
  with
  | Not_found ->
      raise (Parse_error "word/document.xml not found in DOCX file")
  | Zip.Error (_, _, msg) -> raise (Parse_error ("ZIP error: " ^ msg))

(* XML에서 단락 추출 *)
let rec extract_paragraphs input acc =
  match Xmlm.input input with
  | `El_start ((_, tag), _) -> (
    match tag with
    | "p" -> (
        let text_parts = extract_paragraph_text input [] in
        let paragraph = String.concat "" text_parts in
        match String.trim paragraph <> "" with
        | true -> extract_paragraphs input (paragraph :: acc)
        | false -> extract_paragraphs input acc )
    | "body" | "document" -> extract_paragraphs input acc
    | _ ->
        skip_element input 1;
        extract_paragraphs input acc )
  | `El_end -> acc
  | `Data _ -> extract_paragraphs input acc
  | `Dtd _ -> extract_paragraphs input acc

(* XML 문자열을 파싱하여 단락 추출 *)
let parse_document_xml xml_content =
  let input = Xmlm.make_input (`String (0, xml_content)) in
  try List.rev (extract_paragraphs input [])
  with Xmlm.Error ((line, col), error) ->
    let msg =
      Printf.sprintf "XML parse error at line %d, col %d: %s" line col
        (Xmlm.error_message error)
    in
    raise (Parse_error msg)

(* 단락을 Markdown 형식으로 변환 *)
let paragraphs_to_markdown paragraphs =
  String.concat "\n\n" paragraphs ^ "\n"

(* DOCX를 Markdown으로 변환 *)
let convert_docx_to_markdown input_path output_path =
  try
    let xml_content = extract_document_xml input_path in
    let paragraphs = parse_document_xml xml_content in
    let markdown = paragraphs_to_markdown paragraphs in
    let oc = open_out output_path in
    output_string oc markdown;
    close_out oc;
    Printf.printf "Successfully converted %s to %s\n" input_path output_path;
    Ok ()
  with
  | Parse_error msg ->
      Printf.eprintf "Error: %s\n" msg;
      Error msg
  | Sys_error msg ->
      Printf.eprintf "System error: %s\n" msg;
      Error msg
  | e ->
      let msg = Printexc.to_string e in
      Printf.eprintf "Unexpected error: %s\n" msg;
      Error msg
