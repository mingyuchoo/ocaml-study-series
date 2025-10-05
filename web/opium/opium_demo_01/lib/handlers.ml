(* HTTP 핸들러 구현 *)
open Opium

let print_person_handler req =
  let name = Router.param req "name" in
  let age_str = Router.param req "age" in
  let age = try int_of_string age_str with _ -> 0 in
  let person = Person.{ name; age } |> Person.yojson_of_t in
  Lwt.return (Response.of_json person)

let update_person_handler req =
  let open Lwt.Syntax in
  let+ json = Request.to_json_exn req in
  let _person = Person.t_of_yojson json in
  Response.of_json (`Assoc [("message", `String "Person saved")])

let streaming_handler _req =
  Response.of_plain_text "STREAMING DISABLED" |> Lwt.return

let print_param_handler req =
  let name = Router.param req "name" in
  Printf.sprintf "Hello, %s\n" name |> Response.of_plain_text |> Lwt.return
