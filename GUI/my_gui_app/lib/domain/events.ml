(** Domain Events - 도메인 이벤트 *)

type t =
  | NameChanged of string
  | PhoneChanged of string
  | EmailChanged of string
  | AddressChanged of string
  | SearchChanged of string
  | AddContact
  | UpdateContact
  | DeleteContact
  | SelectContact of int
  | ClearForm
  | QuitRequested
