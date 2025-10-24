/* Presentation Layer - Web Handlers */

open Lwt.Syntax;

let service_ref: ref(option(Domain.Contact_repository.t)) = ref(None);

let set_service = service => service_ref := Some(service);

let get_service = (): Domain.Contact_repository.t =>
  switch (service_ref^) {
  | Some(s) => s
  | None => failwith("Service not initialized")
  };

/* HTML Templates */
let html_layout = (title, content) => {
  "<!DOCTYPE html>
<html lang=\"ko\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <title>"
  ++ title
  ++ "</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1 { color: #333; }
    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
    th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #4CAF50; color: white; }
    tr:hover { background-color: #f5f5f5; }
    .btn { padding: 8px 16px; margin: 4px; text-decoration: none; color: white; border-radius: 4px; display: inline-block; }
    .btn-primary { background-color: #4CAF50; }
    .btn-danger { background-color: #f44336; }
    .btn-secondary { background-color: #008CBA; }
    form { background: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; }
    input, textarea { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; }
    label { font-weight: bold; }
  </style>
</head>
<body>
  <h1>주소록 관리</h1>
  <nav>
    <a href=\"/\" class=\"btn btn-secondary\">홈</a>
    <a href=\"/contacts/new\" class=\"btn btn-primary\">새 연락처 추가</a>
  </nav>
  "
  ++ content
  ++ "
</body>
</html>";
};

let index_handler = request => {
  let repo = get_service();
  let* contacts = Application.Contact_service.get_all_contacts(repo);
  let rows =
    List.map(
      contact =>
        switch (Domain.Contact.id(contact)) {
        | None => ""
        | Some(id) =>
          "<tr>
          <td>"
          ++ string_of_int(id)
          ++ "</td>
          <td>"
          ++ Domain.Contact.name(contact)
          ++ "</td>
          <td>"
          ++ Domain.Contact.email(contact)
          ++ "</td>
          <td>"
          ++ Domain.Contact.phone(contact)
          ++ "</td>
          <td>"
          ++ Domain.Contact.address(contact)
          ++ "</td>
          <td>
            <a href=\"/contacts/"
          ++ string_of_int(id)
          ++ "/edit\" class=\"btn btn-secondary\">수정</a>
            <form method=\"POST\" action=\"/contacts/"
          ++ string_of_int(id)
          ++ "/delete\" style=\"display:inline;\">
              "
          ++ Dream.csrf_tag(request)
          ++ "
              <button type=\"submit\" class=\"btn btn-danger\">삭제</button>
            </form>
          </td>
        </tr>"
        },
      contacts,
    )
    |> String.concat("\n");

  let content =
    "
    <h2>연락처 목록</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>이름</th>
          <th>이메일</th>
          <th>전화번호</th>
          <th>주소</th>
          <th>작업</th>
        </tr>
      </thead>
      <tbody>
        "
    ++ rows
    ++ "
      </tbody>
    </table>
  ";

  Dream.html(html_layout("주소록", content));
};

let new_contact_form = request => {
  let content =
    "
    <h2>새 연락처 추가</h2>
    <form method=\"POST\" action=\"/contacts\">
      "
    ++ Dream.csrf_tag(request)
    ++ "
      <label>이름:</label>
      <input type=\"text\" name=\"name\" required>

      <label>이메일:</label>
      <input type=\"email\" name=\"email\" required>

      <label>전화번호:</label>
      <input type=\"tel\" name=\"phone\" required>

      <label>주소:</label>
      <textarea name=\"address\" rows=\"3\" required></textarea>

      <button type=\"submit\" class=\"btn btn-primary\">저장</button>
      <a href=\"/\" class=\"btn btn-secondary\">취소</a>
    </form>
  ";

  Dream.html(html_layout("새 연락처", content));
};

let create_contact_handler = request => {
  let repo = get_service();
  let* form = Dream.form(request);
  switch (form) {
  | `Ok(fields) =>
    let name = List.assoc("name", fields);
    let email = List.assoc("email", fields);
    let phone = List.assoc("phone", fields);
    let address = List.assoc("address", fields);
    let* result =
      Application.Contact_service.create_contact(
        repo,
        name,
        email,
        phone,
        address,
      );
    switch (result) {
    | Ok(_) => Dream.redirect(request, "/")
    | Error(msg) =>
      let content =
        "<p style=\"color: red;\">오류: "
        ++ msg
        ++ "</p>
             <a href=\"/contacts/new\" class=\"btn btn-secondary\">다시 시도</a>";
      Dream.html(html_layout("오류", content));
    };
  | `Many_tokens(_)
  | `Missing_token(_)
  | `Invalid_token(_)
  | `Wrong_content_type
  | `Wrong_session(_)
  | `Expired(_) => Dream.html(~status=`Bad_Request, "Invalid form data")
  };
};

let edit_contact_form = request => {
  let repo = get_service();
  let id = int_of_string(Dream.param(request, "id"));
  let* contact_opt = Application.Contact_service.get_contact_by_id(repo, id);
  switch (contact_opt) {
  | None => Dream.html(~status=`Not_Found, "Contact not found")
  | Some(contact) =>
    let content =
      "
        <h2>연락처 수정</h2>
        <form method=\"POST\" action=\"/contacts/"
      ++ string_of_int(id)
      ++ "\">
          "
      ++ Dream.csrf_tag(request)
      ++ "
          <label>이름:</label>
          <input type=\"text\" name=\"name\" value=\""
      ++ Domain.Contact.name(contact)
      ++ "\" required>

          <label>이메일:</label>
          <input type=\"email\" name=\"email\" value=\""
      ++ Domain.Contact.email(contact)
      ++ "\" required>

          <label>전화번호:</label>
          <input type=\"tel\" name=\"phone\" value=\""
      ++ Domain.Contact.phone(contact)
      ++ "\" required>

          <label>주소:</label>
          <textarea name=\"address\" rows=\"3\" required>"
      ++ Domain.Contact.address(contact)
      ++ "</textarea>

          <button type=\"submit\" class=\"btn btn-primary\">저장</button>
          <a href=\"/\" class=\"btn btn-secondary\">취소</a>
        </form>
      ";
    Dream.html(html_layout("연락처 수정", content));
  };
};

let update_contact_handler = request => {
  let repo = get_service();
  let id = int_of_string(Dream.param(request, "id"));
  let* form = Dream.form(request);
  switch (form) {
  | `Ok(fields) =>
    let name = List.assoc("name", fields);
    let email = List.assoc("email", fields);
    let phone = List.assoc("phone", fields);
    let address = List.assoc("address", fields);
    let* result =
      Application.Contact_service.update_contact(
        repo,
        id,
        name,
        email,
        phone,
        address,
      );
    switch (result) {
    | Ok(_) => Dream.redirect(request, "/")
    | Error(msg) =>
      let content =
        "<p style=\"color: red;\">오류: "
        ++ msg
        ++ "</p>
             <a href=\"/contacts/"
        ++ string_of_int(id)
        ++ "/edit\" class=\"btn btn-secondary\">다시 시도</a>";
      Dream.html(html_layout("오류", content));
    };
  | _ => Dream.html(~status=`Bad_Request, "Invalid form data")
  };
};

let delete_contact_handler = request => {
  let repo = get_service();
  let id = int_of_string(Dream.param(request, "id"));
  let* _ = Application.Contact_service.delete_contact(repo, id);
  Dream.redirect(request, "/");
};

/* REST API Handlers */
let api_list_contacts = _request => {
  let repo = get_service();
  let* contacts = Application.Contact_service.get_all_contacts(repo);
  let json = Contact_dto.contacts_to_json(contacts);
  Dream.json(Yojson.Safe.to_string(json));
};

let api_get_contact = request => {
  let repo = get_service();
  let id = int_of_string(Dream.param(request, "id"));
  let* contact_opt = Application.Contact_service.get_contact_by_id(repo, id);
  switch (contact_opt) {
  | None =>
    Dream.json(~status=`Not_Found, "{\"error\": \"Contact not found\"}")
  | Some(contact) =>
    let json = Contact_dto.contact_to_json(contact);
    Dream.json(Yojson.Safe.to_string(json));
  };
};

let api_create_contact = request => {
  let repo = get_service();
  let* body = Dream.body(request);
  let json = Yojson.Safe.from_string(body);
  switch (Contact_dto.json_to_contact(json)) {
  | Ok((name, email, phone, address)) =>
    let* result =
      Application.Contact_service.create_contact(
        repo,
        name,
        email,
        phone,
        address,
      );
    switch (result) {
    | Ok(contact) =>
      let json = Contact_dto.contact_to_json(contact);
      Dream.json(~status=`Created, Yojson.Safe.to_string(json));
    | Error(msg) =>
      let json = Contact_dto.error_to_json(msg);
      Dream.json(~status=`Bad_Request, Yojson.Safe.to_string(json));
    };
  | Error(msg) =>
    let json = Contact_dto.error_to_json(msg);
    Dream.json(~status=`Bad_Request, Yojson.Safe.to_string(json));
  };
};
