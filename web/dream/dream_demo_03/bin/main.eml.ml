open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module type DB = Caqti_lwt.CONNECTION
module T = Caqti_type

type user = {id : int; name : string}

let hardcoded_users = [
    {id = 1; name = "alice"};
    {id = 2; name = "bob"};
  ]

let user =
  Graphql_lwt.Schema.(obj "user"
    ~fields:[
      field "id"
        ~typ:(non_null int)
        ~args:Arg.[]
        ~resolve:(fun _info user -> user.id);
      field "name"
        ~typ:(non_null string)
        ~args:Arg.[]
        ~resolve:(fun _info user -> user.name);
    ])

let schema =
  Graphql_lwt.Schema.(schema [
    field "users"
      ~typ:(non_null (list (non_null user)))
      ~args:Arg.[arg "id" ~typ:int]
      ~resolve:(fun _info () id ->
        match id with
        | None -> hardcoded_users
        | Some id' ->
          match List.find_opt (fun {id; _} -> id = id') hardcoded_users with
          | None -> []
          | Some user -> [user]);
  ])


let default_query =
  "{\\n  users {\\n    name\\n    id\\n  }\\n}\\n"

let list_comments =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(t2 int string))
    "SELECT id, text FROM comment" in
  fun (module Db : DB) ->
    let%lwt comments_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_or_error

let add_comment =
  let query =
    let open Caqti_request.Infix in
    (T.string ->. T.unit)
    "INSERT INTO comment (text) VALUES ($1)" in
  fun text (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query text in
    Caqti_lwt.or_fail unit_or_error

let render_db comments request =
  <html>
  <body>
%   comments |> List.iter (fun (_id, comment) ->
      <p><%s comment %></p><% ); %>
    <form method="POST" action="/db">
      <%s! Dream.csrf_tag request %>
      <input name="text" autofocus>
    </form>
  </body>
  </html>
 
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

let render_word param =
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
  Dream.run
    (* ~tls:true *)
    ~error_handler:(Dream.error_template my_error_template)
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.sql_sessions
  @@ Dream.origin_referrer_check
  @@ count_requests
  @@ Dream.router [
    Dream.get "/" (fun request -> Dream.html (show_form request));
    Dream.post "/" (fun request -> match%lwt Dream.form request with
        | `Ok ["message", message] -> Dream.html (show_form ~message request)
        | _                        -> Dream.empty `Bad_Request);
    Dream.post "/json" (fun request ->
        let%lwt body = Dream.body request in
        let message_object = body
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
        Dream.param request "word" |> render_word |> Dream.html);
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
    Dream.get "/db" (fun request -> 
      let%lwt comments = Dream.sql request list_comments in
      Dream.html (render_db comments request));
    Dream.post "/db" (fun request ->
      match%lwt Dream.form request with
      | `Ok ["text", text] -> let%lwt () = Dream.sql request (add_comment text) in Dream.redirect request "/db"
      | _                  -> Dream.empty `Bad_Request);
    Dream.any "/graphql" (Dream.graphql Lwt.return schema);
    Dream.get "/graphiql" (Dream.graphiql ~default_query "/graphql");
  ]


