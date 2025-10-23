let () =
  let input_file = "input/애국가.docx" in
  let output_file = "output/애국가.md" in
  (* output 디렉터리가 없으면 생성 *)
  ( match Sys.file_exists "output" with
  | false -> Unix.mkdir "output" 0o755
  | true -> () );
  match
    Korean_docx_parser.convert_docx_to_markdown input_file output_file
  with
  | Ok () -> exit 0
  | Error _ -> exit 1
