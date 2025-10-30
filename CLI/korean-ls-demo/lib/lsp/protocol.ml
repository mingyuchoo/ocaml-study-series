(** LSP Protocol Message Handling *)

open Types

(** Read a line from stdin *)
let read_line () = try Some (input_line stdin) with End_of_file -> None

(** Read exactly n bytes from stdin *)
let read_content length =
  let buffer = Bytes.create length in
  really_input stdin buffer 0 length;
  Bytes.to_string buffer

(** Parse headers from stdin until empty line *)
let rec read_headers acc =
  match read_line () with
  | None -> acc
  | Some "" -> acc
  | Some line -> (
    (* Parse header in format "Name: Value" *)
    match String.split_on_char ':' line with
    | name :: rest ->
        let value = String.trim (String.concat ":" rest) in
        read_headers ((String.trim name, value) :: acc)
    | [] -> read_headers acc )

(** Extract Content-Length from headers *)
let get_content_length headers =
  try
    let _, value =
      List.find
        (fun (name, _) -> String.lowercase_ascii name = "content-length")
        headers
    in
    Some (int_of_string value)
  with
  | Not_found -> None
  | Failure _ -> None

(** Parse JSON string to message *)
let parse_message json_str =
  try
    let json = Yojson.Safe.from_string json_str in
    match Yojson.Safe.Util.member "id" json with
    | `Null ->
        (* This is a notification *)
        let method_ =
          Yojson.Safe.Util.member "method" json |> Yojson.Safe.Util.to_string
        in
        let params =
          match Yojson.Safe.Util.member "params" json with
          | `Null -> None
          | p -> Some p
        in
        Some (Notification { method_; params })
    | id_json -> (
        (* This has an id, so it's either a request or response *)
        let id = Yojson.Safe.Util.to_int id_json in
        match Yojson.Safe.Util.member "method" json with
        | `Null ->
            (* This is a response *)
            let result =
              match Yojson.Safe.Util.member "result" json with
              | `Null -> None
              | r -> Some r
            in
            let error =
              match Yojson.Safe.Util.member "error" json with
              | `Null -> None
              | e -> (
                match response_error_of_yojson e with
                | Ok err -> Some err
                | Error _ -> None )
            in
            Some (Response { id; result; error })
        | method_json ->
            (* This is a request *)
            let method_ = Yojson.Safe.Util.to_string method_json in
            let params =
              match Yojson.Safe.Util.member "params" json with
              | `Null -> None
              | p -> Some p
            in
            Some (Request { id; method_; params }) )
  with _ -> None

(** Read a complete LSP message from stdin *)
let read_message () =
  try
    let headers = read_headers [] in
    match get_content_length headers with
    | None -> None
    | Some length ->
        let content = read_content length in
        parse_message content
  with
  | End_of_file -> None
  | _ -> None

(** Convert message to JSON *)
let message_to_json = function
  | Request { id; method_; params } ->
      let base =
        [ ("jsonrpc", `String "2.0");
          ("id", `Int id);
          ("method", `String method_) ]
      in
      let with_params =
        match params with
        | None -> base
        | Some p -> base @ [("params", p)]
      in
      `Assoc with_params
  | Response { id; result; error } ->
      let base = [("jsonrpc", `String "2.0"); ("id", `Int id)] in
      let with_result =
        match result with
        | None -> base
        | Some r -> base @ [("result", r)]
      in
      let with_error =
        match error with
        | None -> with_result
        | Some e -> with_result @ [("error", response_error_to_yojson e)]
      in
      `Assoc with_error
  | Notification { method_; params } ->
      let base = [("jsonrpc", `String "2.0"); ("method", `String method_)] in
      let with_params =
        match params with
        | None -> base
        | Some p -> base @ [("params", p)]
      in
      `Assoc with_params

(** Write a message to stdout with LSP headers *)
let write_message message =
  let json = message_to_json message in
  let content = Yojson.Safe.to_string json in
  let length = String.length content in
  Printf.printf "Content-Length: %d\r\n\r\n%s%!" length content

(** Create a response message *)
let make_response id result =
  Response { id; result= Some result; error= None }

(** Create an error response *)
let make_error_response id code message =
  let error =
    { code=
        ( match code with
        | ParseError -> -32700
        | InvalidRequest -> -32600
        | MethodNotFound -> -32601
        | InvalidParams -> -32602
        | InternalError -> -32603
        | ServerNotInitialized -> -32002
        | UnknownErrorCode -> -32001 );
      message;
      data= None
    }
  in
  Response { id; result= None; error= Some error }

(** Create a notification message *)
let make_notification method_ params =
  Notification { method_; params= Some params }
