(* Symbol Table for Korean Language Server *)

open Ast

(* Symbol kind *)
type symbol_kind = Variable | Function | Parameter

(* Symbol definition *)
type symbol =
  { name: string;
    kind: symbol_kind;
    definition_range: range;
    type_: string option
  }

(* Scope with parent chain *)
type scope = { symbols: (string, symbol) Hashtbl.t; parent: scope option }

(* Create a new scope *)
let create_scope parent = { symbols= Hashtbl.create 16; parent }

(* Create a root scope *)
let create_root_scope () = create_scope None

(* Add a symbol to the current scope *)
let add_symbol scope name kind definition_range type_ =
  let symbol = { name; kind; definition_range; type_ } in
  Hashtbl.replace scope.symbols name symbol;
  symbol

(* Look up a symbol in the current scope only *)
let lookup_local scope name = Hashtbl.find_opt scope.symbols name

(* Look up a symbol in the scope chain (current scope and parents) *)
let rec lookup scope name =
  match lookup_local scope name with
  | Some symbol -> Some symbol
  | None -> (
    match scope.parent with
    | Some parent -> lookup parent name
    | None -> None )

(* Check if a symbol exists in the current scope only *)
let exists_local scope name = Hashtbl.mem scope.symbols name

(* Check if a symbol exists in the scope chain *)
let rec exists scope name =
  exists_local scope name
  ||
  match scope.parent with
  | Some parent -> exists parent name
  | None -> false

(* Get all symbols in the current scope *)
let get_all_symbols scope =
  Hashtbl.fold (fun _ symbol acc -> symbol :: acc) scope.symbols []

(* Get all symbols in the scope chain *)
let rec get_all_symbols_in_chain scope =
  let local_symbols = get_all_symbols scope in
  match scope.parent with
  | Some parent -> local_symbols @ get_all_symbols_in_chain parent
  | None -> local_symbols
