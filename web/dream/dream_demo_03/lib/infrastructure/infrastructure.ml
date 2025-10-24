(* Infrastructure Layer - Database implementation *)

open Domain

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let address_type =
  let encode { id; name; phone; email; address } =
    Ok (id, name, phone, email, address)
  in
  let decode (id, name, phone, email, address) =
    Ok { id; name; phone; email; address }
  in
  T.(custom ~encode ~decode (t5 (option int) string string string string))

module SqliteRepository : REPOSITORY with type db = (module DB) = struct
  type db = (module DB)

  let create_query =
    let open Caqti_request.Infix in
    (T.(t4 string string string string) ->! T.int)
    @@ "INSERT INTO addresses (name, phone, email, address) VALUES (?, ?, \
        ?, ?) RETURNING id"

  let read_query =
    let open Caqti_request.Infix in
    (T.int ->? T.(t5 int string string string string))
    @@ "SELECT id, name, phone, email, address FROM addresses WHERE id = ?"

  let read_all_query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(t5 int string string string string))
    @@ "SELECT id, name, phone, email, address FROM addresses ORDER BY name"

  let update_query =
    let open Caqti_request.Infix in
    (T.(t5 string string string string int) ->. T.unit)
    @@ "UPDATE addresses SET name = ?, phone = ?, email = ?, address = ? \
        WHERE id = ?"

  let delete_query =
    let open Caqti_request.Infix in
    (T.int ->. T.unit) @@ "DELETE FROM addresses WHERE id = ?"

  let create input (module Db : DB) =
    let%lwt id_or_error =
      Db.find create_query
        (input.name, input.phone, input.email, input.address)
    in
    Caqti_lwt.or_fail id_or_error

  let read id (module Db : DB) =
    let%lwt result = Db.find_opt read_query id in
    match%lwt Caqti_lwt.or_fail result with
    | None -> Lwt.return None
    | Some (id, name, phone, email, address) ->
        Lwt.return (Some { id= Some id; name; phone; email; address })

  let read_all (module Db : DB) =
    let%lwt results = Db.collect_list read_all_query () in
    let%lwt rows = Caqti_lwt.or_fail results in
    Lwt.return
      (List.map
         (fun (id, name, phone, email, address) ->
           { id= Some id; name; phone; email; address } )
         rows )

  let update id input (module Db : DB) =
    let%lwt result =
      Db.exec update_query
        (input.name, input.phone, input.email, input.address, id)
    in
    Caqti_lwt.or_fail result

  let delete id (module Db : DB) =
    let%lwt result = Db.exec delete_query id in
    Caqti_lwt.or_fail result
end
