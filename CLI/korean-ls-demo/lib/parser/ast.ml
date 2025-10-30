(* AST type definitions for Korean Language Server *)

type position = { line: int; character: int } [@@deriving yojson]

type range = { start: position; end_: position [@key "end"] }
[@@deriving yojson]

type expr =
  | Identifier of string * range
  | Number of int * range
  | String of string * range
  | FunctionCall of { name: string; args: expr list; range: range }
  | Assignment of { name: string; value: expr; range: range }
[@@deriving yojson]

type statement =
  | Expression of expr
  | FunctionDef of
      { name: string;
        params: string list;
        body: statement list;
        range: range
      }
  | Return of expr option * range
[@@deriving yojson]

type program = statement list [@@deriving yojson]

type parse_error = { message: string; range: range } [@@deriving yojson]
