(** Domain Types - 비즈니스 엔티티 *)

(** 연락처 엔티티 *)
type contact =
  { id: int option;
    name: string;
    phone: string;
    email: string;
    address: string
  }

(** 애플리케이션 상태 *)
type app_state =
  { contacts: contact list;
    selected_contact: contact option;
    name_input: string;
    phone_input: string;
    email_input: string;
    address_input: string;
    search_query: string
  }

(** 빈 연락처 *)
let empty_contact = { id= None; name= ""; phone= ""; email= ""; address= "" }

(** 초기 상태 *)
let initial_state =
  { contacts= [];
    selected_contact= None;
    name_input= "";
    phone_input= "";
    email_input= "";
    address_input= "";
    search_query= ""
  }
