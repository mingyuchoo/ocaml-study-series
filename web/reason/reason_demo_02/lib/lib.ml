(* Library entry point - exports all modules *)

module Contact = Domain.Contact
module Contact_repository = Domain.Contact_repository
module Sqlite_contact_repository = Infrastructure.Sqlite_contact_repository
module Contact_service = Application.Contact_service
module Contact_dto = Presentation.Contact_dto
module Web_handlers = Presentation.Web_handlers
