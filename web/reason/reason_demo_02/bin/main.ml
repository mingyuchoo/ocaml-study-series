(* Main entry point - Web server *)

open Lwt.Syntax
open Reason_demo_02

let () =
  Lwt_main.run
    (let* repo = Sqlite_contact_repository.make () in
     Web_handlers.set_service repo;
     Lwt.return () );
  Dream.run ~port:8080
  @@ Dream.logger
  @@ Dream.router
       [ (* Web UI Routes *)
         Dream.get "/" Web_handlers.index_handler;
         Dream.get "/contacts/new" Web_handlers.new_contact_form;
         Dream.post "/contacts" Web_handlers.create_contact_handler;
         Dream.get "/contacts/:id/edit" Web_handlers.edit_contact_form;
         Dream.post "/contacts/:id" Web_handlers.update_contact_handler;
         Dream.post "/contacts/:id/delete"
           Web_handlers.delete_contact_handler;
         (* REST API Routes *)
         Dream.get "/api/contacts" Web_handlers.api_list_contacts;
         Dream.get "/api/contacts/:id" Web_handlers.api_get_contact;
         Dream.post "/api/contacts" Web_handlers.api_create_contact ]
