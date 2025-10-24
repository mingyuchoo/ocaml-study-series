(* Main entry point - Wiring all layers together *)

open Dream_demo_03

(* Initialize the service with repository *)
module Service = Application.AddressService(Infrastructure.SqliteRepository)

(* Initialize handlers with service *)
module Handlers = Presentation.AddressHandlers(Service)

(* Database initialization *)
let init_db =
  let create_addresses_table =
    let open Caqti_request.Infix in
    Caqti_type.unit ->. Caqti_type.unit @@
    "CREATE TABLE IF NOT EXISTS addresses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      email TEXT NOT NULL,
      address TEXT NOT NULL
    )"
  in
  let create_session_table =
    let open Caqti_request.Infix in
    Caqti_type.unit ->. Caqti_type.unit @@
    "CREATE TABLE IF NOT EXISTS dream_session (
      id TEXT PRIMARY KEY,
      label TEXT NOT NULL,
      expires_at REAL NOT NULL,
      payload TEXT NOT NULL
    )"
  in
  fun (module Db : Infrastructure.DB) ->
    let%lwt result1 = Db.exec create_addresses_table () in
    let%lwt () = Caqti_lwt.or_fail result1 in
    let%lwt result2 = Db.exec create_session_table () in
    let%lwt () = Caqti_lwt.or_fail result2 in
    Lwt.return_unit

let initialized = ref false

let ensure_db_initialized handler request =
  if not !initialized then begin
    let%lwt () = Dream.sql request init_db in
    initialized := true;
    handler request
  end else
    handler request

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ ensure_db_initialized
  @@ Dream.sql_sessions
  @@ Dream.origin_referrer_check
  @@ Dream.router [
    Dream.get "/" (fun _request ->
      Dream.redirect _request "/addresses");
    
    (* Address book routes *)
    Dream.get "/addresses" Handlers.list_handler;
    Dream.get "/addresses/new" Handlers.new_form_handler;
    Dream.post "/addresses" Handlers.create_handler;
    Dream.get "/addresses/:id/edit" Handlers.edit_form_handler;
    Dream.post "/addresses/:id" Handlers.update_handler;
    Dream.post "/addresses/:id/delete" Handlers.delete_handler;
  ]
