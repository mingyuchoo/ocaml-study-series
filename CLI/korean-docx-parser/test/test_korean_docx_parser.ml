(* 간단한 테스트 *)
let test_conversion () =
  (* 테스트는 프로젝트 루트에서 실행되도록 경로 조정 *)
  let input_file =
    if Sys.file_exists "input/애국가.docx" then "input/애국가.docx"
    else if Sys.file_exists "../input/애국가.docx" then "../input/애국가.docx"
    else "../../input/애국가.docx"
  in
  if not (Sys.file_exists input_file) then (
    Printf.printf "Test skipped: Input file not found at %s\n" input_file;
    exit 0 );
  let output_dir =
    if Sys.file_exists "output" then "output"
    else if Sys.file_exists "../output" then "../output"
    else "../../output"
  in
  let output_file = Filename.concat output_dir "test_애국가.md" in
  match
    Korean_docx_parser.convert_docx_to_markdown input_file output_file
  with
  | Ok () ->
      Printf.printf "Test passed: Successfully converted DOCX to Markdown\n";
      if Sys.file_exists output_file then
        Printf.printf "Output file exists: %s\n" output_file
      else Printf.printf "Warning: Output file not found\n"
  | Error msg ->
      Printf.printf "Test failed: %s\n" msg;
      exit 1

let () = test_conversion ()
