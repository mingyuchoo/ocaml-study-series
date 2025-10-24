(** Infrastructure - SQLite 데이터베이스 어댑터 *)

open Domain.Types

(** 데이터베이스 연결 타입 *)
type db = Sqlite3.db

(** 데이터베이스 초기화 *)
let init_db db_path =
  let db = Sqlite3.db_open db_path in
  let create_table =
    {|
    CREATE TABLE IF NOT EXISTS contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      email TEXT NOT NULL,
      address TEXT NOT NULL
    )
  |}
  in
  ignore (Sqlite3.exec db create_table);
  db

(** 모든 연락처 조회 *)
let get_all_contacts db =
  let contacts = ref [] in
  let stmt =
    Sqlite3.prepare db
      "SELECT id, name, phone, email, address FROM contacts ORDER BY name"
  in
  let rec fetch_all () =
    match Sqlite3.step stmt with
    | Sqlite3.Rc.ROW ->
        let id = Sqlite3.column_int stmt 0 in
        let name = Sqlite3.column_text stmt 1 in
        let phone = Sqlite3.column_text stmt 2 in
        let email = Sqlite3.column_text stmt 3 in
        let address = Sqlite3.column_text stmt 4 in
        let contact = { id= Some id; name; phone; email; address } in
        contacts := contact :: !contacts;
        fetch_all ()
    | _ -> ()
  in
  fetch_all ();
  Sqlite3.finalize stmt |> ignore;
  List.rev !contacts

(** 연락처 추가 *)
let add_contact db contact =
  let stmt =
    Sqlite3.prepare db
      "INSERT INTO contacts (name, phone, email, address) VALUES (?, ?, ?, \
       ?)"
  in
  Sqlite3.bind stmt 1 (Sqlite3.Data.TEXT contact.name) |> ignore;
  Sqlite3.bind stmt 2 (Sqlite3.Data.TEXT contact.phone) |> ignore;
  Sqlite3.bind stmt 3 (Sqlite3.Data.TEXT contact.email) |> ignore;
  Sqlite3.bind stmt 4 (Sqlite3.Data.TEXT contact.address) |> ignore;
  let result = Sqlite3.step stmt in
  Sqlite3.finalize stmt |> ignore;
  result = Sqlite3.Rc.DONE

(** 연락처 수정 *)
let update_contact db contact =
  match contact.id with
  | None -> false
  | Some id ->
      let stmt =
        Sqlite3.prepare db
          "UPDATE contacts SET name=?, phone=?, email=?, address=? WHERE \
           id=?"
      in
      Sqlite3.bind stmt 1 (Sqlite3.Data.TEXT contact.name) |> ignore;
      Sqlite3.bind stmt 2 (Sqlite3.Data.TEXT contact.phone) |> ignore;
      Sqlite3.bind stmt 3 (Sqlite3.Data.TEXT contact.email) |> ignore;
      Sqlite3.bind stmt 4 (Sqlite3.Data.TEXT contact.address) |> ignore;
      Sqlite3.bind stmt 5 (Sqlite3.Data.INT (Int64.of_int id)) |> ignore;
      let result = Sqlite3.step stmt in
      Sqlite3.finalize stmt |> ignore;
      result = Sqlite3.Rc.DONE

(** 연락처 삭제 *)
let delete_contact db contact_id =
  let stmt = Sqlite3.prepare db "DELETE FROM contacts WHERE id=?" in
  Sqlite3.bind stmt 1 (Sqlite3.Data.INT (Int64.of_int contact_id)) |> ignore;
  let result = Sqlite3.step stmt in
  Sqlite3.finalize stmt |> ignore;
  result = Sqlite3.Rc.DONE

(** 데이터베이스 닫기 *)
let close_db db = ignore (Sqlite3.db_close db)
