(** Application Use Cases - 비즈니스 로직 *)

open Domain.Types

(** 입력 필드 업데이트 *)
let update_name state name = { state with name_input= name }

let update_phone state phone = { state with phone_input= phone }

let update_email state email = { state with email_input= email }

let update_address state address = { state with address_input= address }

let update_search state query = { state with search_query= query }

(** 폼 초기화 *)
let clear_form state =
  { state with
    selected_contact= None;
    name_input= "";
    phone_input= "";
    email_input= "";
    address_input= ""
  }

(** 연락처 선택 *)
let select_contact state contact_id =
  match List.find_opt (fun c -> c.id = Some contact_id) state.contacts with
  | Some contact ->
      { state with
        selected_contact= Some contact;
        name_input= contact.name;
        phone_input= contact.phone;
        email_input= contact.email;
        address_input= contact.address
      }
  | None -> state

(** 연락처 목록 업데이트 *)
let update_contacts state contacts = { state with contacts }

(** 문자열 포함 여부 확인 *)
let string_contains haystack needle =
  try
    let _ = Str.search_forward (Str.regexp_string needle) haystack 0 in
    true
  with Not_found -> false

(** 연락처 검색 필터링 *)
let filter_contacts state =
  if state.search_query = "" then state.contacts
  else
    let query = String.lowercase_ascii state.search_query in
    List.filter
      (fun c ->
        let name = String.lowercase_ascii c.name in
        let phone = String.lowercase_ascii c.phone in
        let email = String.lowercase_ascii c.email in
        string_contains name query
        || string_contains phone query
        || string_contains email query )
      state.contacts

(** 이벤트 처리 *)
let handle_event state event =
  match event with
  | Domain.Events.NameChanged text -> update_name state text
  | Domain.Events.PhoneChanged text -> update_phone state text
  | Domain.Events.EmailChanged text -> update_email state text
  | Domain.Events.AddressChanged text -> update_address state text
  | Domain.Events.SearchChanged text -> update_search state text
  | Domain.Events.ClearForm -> clear_form state
  | Domain.Events.SelectContact id -> select_contact state id
  | Domain.Events.AddContact -> state
  | Domain.Events.UpdateContact -> state
  | Domain.Events.DeleteContact -> state
  | Domain.Events.QuitRequested -> state
