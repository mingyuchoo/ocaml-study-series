(* Domain Layer - Core business entities and repository interface *)

open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type address = {
  id: int option [@yojson.option];
  name: string;
  phone: string;
  email: string;
  address: string;
} [@@deriving yojson]

type address_input = {
  name: string;
  phone: string;
  email: string;
  address: string;
} [@@deriving yojson]

module type REPOSITORY = sig
  type db
  val create : address_input -> db -> int Lwt.t
  val read : int -> db -> address option Lwt.t
  val read_all : db -> address list Lwt.t
  val update : int -> address_input -> db -> unit Lwt.t
  val delete : int -> db -> unit Lwt.t
end
