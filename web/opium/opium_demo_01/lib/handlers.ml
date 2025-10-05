(* HTTP 핸들러 구현 *)
open Opium

let print_person_handler _req =
  (* 파라미터 파싱은 일단 생략하고 기본 응답 *)
  let person = Person.{ name= "unknown"; age= 0 } |> Person.yojson_of_t in
  Lwt.return (Response.of_json person)

let update_person_handler req =
  let open Lwt.Syntax in
  let+ json = Request.to_json_exn req in
  let _person = Person.t_of_yojson json in
  Response.of_json (`Assoc [("message", `String "Person saved")])

let streaming_handler _req =
  Response.of_plain_text "STREAMING DISABLED" |> Lwt.return

let print_param_handler _req =
  let name = "world" in
  Printf.sprintf "Hello, %s\n" name |> Response.of_plain_text |> Lwt.return
