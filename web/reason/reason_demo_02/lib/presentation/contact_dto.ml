(* Presentation Layer - Data Transfer Objects *)

type contact_response =
  { id: int; name: string; email: string; phone: string; address: string }

let contact_to_json contact =
  match Domain.Contact.id contact with
  | None -> `Assoc []
  | Some id ->
      `Assoc
        [ ("id", `Int id);
          ("name", `String (Domain.Contact.name contact));
          ("email", `String (Domain.Contact.email contact));
          ("phone", `String (Domain.Contact.phone contact));
          ("address", `String (Domain.Contact.address contact)) ]

let contacts_to_json contacts = `List (List.map contact_to_json contacts)

let json_to_contact json =
  try
    let open Yojson.Safe.Util in
    let name = json |> member "name" |> to_string in
    let email = json |> member "email" |> to_string in
    let phone = json |> member "phone" |> to_string in
    let address = json |> member "address" |> to_string in
    Ok (name, email, phone, address)
  with
  | Yojson.Safe.Util.Type_error (msg, _) -> Error ("Invalid JSON: " ^ msg)
  | _ -> Error "Invalid JSON format"

let error_to_json msg = `Assoc [("error", `String msg)]
