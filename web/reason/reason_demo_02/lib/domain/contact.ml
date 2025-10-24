(* Domain Layer - Contact Entity *)

type t =
  { id: int option;
    name: string;
    email: string;
    phone: string;
    address: string
  }

let create ?id name email phone address = { id; name; email; phone; address }

let id t = t.id

let name t = t.name

let email t = t.email

let phone t = t.phone

let address t = t.address

let with_id t id = { t with id= Some id }

let validate t =
  if String.length t.name = 0 then Error "Name cannot be empty"
  else if String.length t.email = 0 then Error "Email cannot be empty"
  else if not (String.contains t.email '@') then Error "Invalid email format"
  else Ok t
