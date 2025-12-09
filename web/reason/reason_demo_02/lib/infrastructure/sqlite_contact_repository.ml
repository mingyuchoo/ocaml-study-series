(* Infrastructure Layer - SQLite Implementation *)

open Lwt.Syntax

let connection_uri = Uri.of_string "sqlite3:addressbook.db"

let pool =
  match Caqti_lwt_unix.connect_pool connection_uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)

let with_connection f =
  let open Lwt.Infix in
  Caqti_lwt_unix.Pool.use f pool
  >>= function
  | Ok result -> Lwt.return result
  | Error err -> Lwt.fail_with (Caqti_error.show err)

let init_db_query =
  let open Caqti_request.Infix in
  (Caqti_type.unit ->. Caqti_type.unit)
  @@ {|
    CREATE TABLE IF NOT EXISTS contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL,
      address TEXT NOT NULL
    )
  |}

let init_db () =
  with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
      Conn.exec init_db_query () )

let find_all_query =
  let open Caqti_request.Infix in
  (Caqti_type.unit ->* Caqti_type.(t5 int string string string string))
  @@ "SELECT id, name, email, phone, address FROM contacts"

let find_all () =
  with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
      let open Lwt.Infix in
      Conn.collect_list find_all_query ()
      >|= Result.map (fun rows ->
          List.map
            (fun (id, name, email, phone, address) ->
              Domain.Contact.create ~id name email phone address )
            rows ) )

let find_by_id_query =
  let open Caqti_request.Infix in
  (Caqti_type.int ->? Caqti_type.(t5 int string string string string))
  @@ "SELECT id, name, email, phone, address FROM contacts WHERE id = ?"

let find_by_id id =
  with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
      let open Lwt.Infix in
      Conn.find_opt find_by_id_query id
      >|= Result.map (function
        | Some (id, name, email, phone, address) ->
            Some (Domain.Contact.create ~id name email phone address)
        | None -> None ) )

let save_query =
  let open Caqti_request.Infix in
  (Caqti_type.(t4 string string string string) ->. Caqti_type.unit)
  @@ "INSERT INTO contacts (name, email, phone, address) VALUES (?, ?, ?, ?)"

let last_insert_id_query =
  let open Caqti_request.Infix in
  (Caqti_type.unit ->! Caqti_type.int) @@ "SELECT last_insert_rowid()"

let save contact =
  with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
      let open Lwt.Infix in
      Conn.exec save_query
        ( Domain.Contact.name contact,
          Domain.Contact.email contact,
          Domain.Contact.phone contact,
          Domain.Contact.address contact )
      >>= function
      | Ok () ->
          Conn.find last_insert_id_query ()
          >|= Result.map (fun id -> Domain.Contact.with_id contact id)
      | Error _ as err -> Lwt.return err )

let update_query =
  let open Caqti_request.Infix in
  (Caqti_type.(t5 string string string string int) ->. Caqti_type.unit)
  @@ "UPDATE contacts SET name = ?, email = ?, phone = ?, address = ? WHERE \
      id = ?"

let update contact =
  match Domain.Contact.id contact with
  | None -> Lwt.return_none
  | Some id ->
      with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
          let open Lwt.Infix in
          Conn.exec update_query
            ( Domain.Contact.name contact,
              Domain.Contact.email contact,
              Domain.Contact.phone contact,
              Domain.Contact.address contact,
              id )
          >|= Result.map (fun () -> Some contact) )

let delete_query =
  let open Caqti_request.Infix in
  (Caqti_type.int ->. Caqti_type.unit) @@ "DELETE FROM contacts WHERE id = ?"

let delete id =
  with_connection (fun (module Conn : Caqti_lwt.CONNECTION) ->
      let open Lwt.Infix in
      Conn.exec delete_query id >|= Result.map (fun () -> true) )

module Repo : Domain.Contact_repository.S = struct
  let find_all = find_all

  let find_by_id = find_by_id

  let save = save

  let update = update

  let delete = delete
end

let make () =
  let* () = init_db () in
  Lwt.return (module Repo : Domain.Contact_repository.S)
