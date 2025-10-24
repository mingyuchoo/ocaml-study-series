(* Application Layer - Use Cases *)

open Lwt.Syntax

type t = Domain.Contact_repository.t

let make repository = repository

let get_all_contacts (module Repo : Domain.Contact_repository.S) =
  Repo.find_all ()

let get_contact_by_id (module Repo : Domain.Contact_repository.S) id =
  Repo.find_by_id id

let create_contact (module Repo : Domain.Contact_repository.S) name email
    phone address =
  let contact = Domain.Contact.create name email phone address in
  match Domain.Contact.validate contact with
  | Ok valid_contact ->
      let* saved = Repo.save valid_contact in
      Lwt.return_ok saved
  | Error msg -> Lwt.return_error msg

let update_contact (module Repo : Domain.Contact_repository.S) id name email
    phone address =
  let contact = Domain.Contact.create ~id name email phone address in
  match Domain.Contact.validate contact with
  | Ok valid_contact -> (
      let* result = Repo.update valid_contact in
      match result with
      | Some c -> Lwt.return_ok c
      | None -> Lwt.return_error "Contact not found" )
  | Error msg -> Lwt.return_error msg

let delete_contact (module Repo : Domain.Contact_repository.S) id =
  Repo.delete id
