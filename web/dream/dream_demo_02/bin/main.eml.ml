open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type message_object = {
  message : string;
} [@@deriving yojson]

let successful = ref 0
let failed = ref 0
let count_requests inner_handler request = 
  try%lwt
    let%lwt response = inner_handler request in
    successful := !successful + 1;
    Lwt.return response
  with exn ->
    failed := !failed + 1;
    raise exn

let render param =
  <html>
  <body>
    <h1>The URL parameter was <%s param %>!</h1>
  </body>
  </html>

let show_form ?message request =
  <html>
  <body>
%   begin match message with
%   | None -> ()
%   | Some message ->
      <p>You entered: <b><%s message %>!</b></p>
%   end;
    <form method="POST" action="/">
      <%s! Dream.csrf_tag request %>
      <input name="message" autofocus>
    </form>
  </body>
  </html>

let home request =
  <html>
  <body>
    <form method="POST" action="/upload" enctype="multipart/form-data">
      <%s! Dream.csrf_tag request %>
      <input name="files" type="file" multiple>
      <button>Submit!</button>
    </form>
  </body>
  </html>

let report files =
  <html>
  <body>
%   files |> List.iter begin fun (name, content) ->
%     let name =
%       match name with
%       | None -> "None"
%       | Some name -> name
%     in
      <p><%s name %>, <%i String.length content %> bytes</p>
%   end;
  </body>
  </html>
    
let my_error_template _error debug_info suggested_response =
  let status = Dream.status suggested_response in
  let code = Dream.status_to_int status and reason = Dream.status_to_string status in
  Dream.set_header suggested_response "Content-Type" Dream.text_html;
  Dream.set_body suggested_response begin
    <html>
      <body>
        <h1><%i code %><%s reason %></h1>
        <pre><%s debug_info %></pre>
      </body>
    </html>
  end;
  Lwt.return suggested_response

let () =
  Dream.run ~error_handler:(Dream.error_template my_error_template)
  @@ Dream.logger
  @@ Dream.origin_referrer_check
  @@ Dream.memory_sessions
  @@ count_requests
  @@ Dream.router [
    Dream.get "/" (fun request -> Dream.html (show_form request));
    Dream.post "/" (fun request -> match%lwt Dream.form request with
        | `Ok ["message", message] -> Dream.html (show_form ~message request)
        | _ -> Dream.empty `Bad_Request);
    Dream.post "/json" (fun request ->
        let%lwt body = Dream.body request in
        let message_object = 
          body
          |> Yojson.Safe.from_string
          |> message_object_of_yojson
        in
        `String message_object.message
        |> Yojson.Safe.to_string
        |> Dream.json);
    Dream.get "/counter" (fun _request ->
        Dream.html (Printf.sprintf "%3i request(s) successful<br>%3i request(s) failed" !successful !failed));
    Dream.get "/echo/:word" (fun request ->
        Dream.html (Dream.param request "word"));
    Dream.get "/url/:word" (fun request ->
        Dream.param request "word" |> render |> Dream.html);
    Dream.get "/status/fail" (fun _request -> 
        Dream.warning (fun log -> log "Raising an exception!");
        raise (Failure "The Web app failed!"));
    Dream.post "/echo" (fun request ->
        let%lwt body = Dream.body request in
        Dream.respond ~headers:["Content-Type", "application/octet-stream"] body);
    Dream.get "/static/**" (Dream.static "./public");
    Dream.get "/upload" (fun request ->
        Dream.html (home request));
    Dream.post "/upload" (fun request ->
        match%lwt Dream.multipart request with
        | `Ok ["files", files] -> Dream.html (report files)
        | _ -> Dream.empty `Bad_Request);
  ]

