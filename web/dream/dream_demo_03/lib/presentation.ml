(* Presentation Layer - Web handlers and HTML templates *)

open Domain
open Lwt.Syntax

module AddressHandlers (Service : sig
  val create_address : address_input -> (module Infrastructure.DB) -> int Lwt.t
  val get_address : int -> (module Infrastructure.DB) -> address option Lwt.t
  val get_all_addresses : (module Infrastructure.DB) -> address list Lwt.t
  val update_address : int -> address_input -> (module Infrastructure.DB) -> unit Lwt.t
  val delete_address : int -> (module Infrastructure.DB) -> unit Lwt.t
end) = struct

  let render_list addresses request =
    let open Printf in
    let rows = addresses |> List.map (fun addr ->
      let id = match addr.id with Some i -> i | None -> 0 in
      sprintf "<tr>
        <td>%s</td>
        <td>%s</td>
        <td>%s</td>
        <td>%s</td>
        <td>
          <a href='/addresses/%d/edit'>수정</a> | 
          <form method='POST' action='/addresses/%d/delete' style='display:inline'>
            %s
            <button type='submit' onclick='return confirm(\"정말 삭제하시겠습니까?\")'>삭제</button>
          </form>
        </td>
      </tr>"
        (Dream.html_escape addr.name)
        (Dream.html_escape addr.phone)
        (Dream.html_escape addr.email)
        (Dream.html_escape addr.address)
        id id (Dream.csrf_tag request)
    ) |> String.concat "\n" in
    
    sprintf "<!DOCTYPE html>
<html>
<head>
  <meta charset='UTF-8'>
  <title>주소록</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1 { color: #333; }
    table { width: 100%%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
    th { background-color: #4CAF50; color: white; }
    tr:nth-child(even) { background-color: #f2f2f2; }
    a { color: #4CAF50; text-decoration: none; }
    a:hover { text-decoration: underline; }
    .btn { display: inline-block; padding: 10px 20px; background-color: #4CAF50; 
           color: white; text-decoration: none; border-radius: 4px; margin-top: 20px; }
    .btn:hover { background-color: #45a049; }
    button { background-color: #f44336; color: white; border: none; padding: 5px 10px; 
             cursor: pointer; border-radius: 3px; }
    button:hover { background-color: #da190b; }
  </style>
</head>
<body>
  <h1>주소록</h1>
  <a href='/addresses/new' class='btn'>새 주소 추가</a>
  <table>
    <thead>
      <tr>
        <th>이름</th>
        <th>전화번호</th>
        <th>이메일</th>
        <th>주소</th>
        <th>작업</th>
      </tr>
    </thead>
    <tbody>
      %s
    </tbody>
  </table>
</body>
</html>" rows

  let render_form ?address request =
    let (name, phone, email, addr, action, title) = match address with
      | None -> ("", "", "", "", "/addresses", "새 주소 추가")
      | Some a -> 
          let id = match a.id with Some i -> i | None -> 0 in
          (a.name, a.phone, a.email, a.address, 
           Printf.sprintf "/addresses/%d" id, "주소 수정")
    in
    Printf.sprintf "<!DOCTYPE html>
<html>
<head>
  <meta charset='UTF-8'>
  <title>%s</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; }
    h1 { color: #333; }
    form { margin-top: 20px; }
    label { display: block; margin-top: 15px; font-weight: bold; }
    input, textarea { width: 100%%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; 
                      border-radius: 4px; box-sizing: border-box; }
    button { margin-top: 20px; padding: 10px 20px; background-color: #4CAF50; 
             color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background-color: #45a049; }
    .cancel { background-color: #999; margin-left: 10px; }
    .cancel:hover { background-color: #777; }
  </style>
</head>
<body>
  <h1>%s</h1>
  <form method='POST' action='%s'>
    %s
    <label>이름: <input name='name' value='%s' required></label>
    <label>전화번호: <input name='phone' value='%s' required></label>
    <label>이메일: <input name='email' type='email' value='%s' required></label>
    <label>주소: <textarea name='address' rows='3' required>%s</textarea></label>
    <button type='submit'>저장</button>
    <a href='/addresses'><button type='button' class='cancel'>취소</button></a>
  </form>
</body>
</html>"
      title title action (Dream.csrf_tag request)
      (Dream.html_escape name)
      (Dream.html_escape phone)
      (Dream.html_escape email)
      (Dream.html_escape addr)

  let list_handler request =
    let* addresses = Dream.sql request Service.get_all_addresses in
    Dream.html (render_list addresses request)

  let new_form_handler request =
    Dream.html (render_form request)

  let create_handler request =
    match%lwt Dream.form request with
    | `Ok ["name", name; "phone", phone; "email", email; "address", address] ->
        let input = {name; phone; email; address} in
        let* _id = Dream.sql request (Service.create_address input) in
        Dream.redirect request "/addresses"
    | _ -> Dream.empty `Bad_Request

  let edit_form_handler request =
    let id = Dream.param request "id" |> int_of_string in
    let* address_opt = Dream.sql request (Service.get_address id) in
    match address_opt with
    | Some address -> Dream.html (render_form ~address request)
    | None -> Dream.empty `Not_Found

  let update_handler request =
    let id = Dream.param request "id" |> int_of_string in
    match%lwt Dream.form request with
    | `Ok ["name", name; "phone", phone; "email", email; "address", address] ->
        let input = {name; phone; email; address} in
        let* () = Dream.sql request (Service.update_address id input) in
        Dream.redirect request "/addresses"
    | _ -> Dream.empty `Bad_Request

  let delete_handler request =
    let id = Dream.param request "id" |> int_of_string in
    let* () = Dream.sql request (Service.delete_address id) in
    Dream.redirect request "/addresses"
end
