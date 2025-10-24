(* Domain Layer - Repository Interface (signature only) *)

module type S = sig
  val find_all : unit -> Contact.t list Lwt.t

  val find_by_id : int -> Contact.t option Lwt.t

  val save : Contact.t -> Contact.t Lwt.t

  val update : Contact.t -> Contact.t option Lwt.t

  val delete : int -> bool Lwt.t
end

type t = (module S)
