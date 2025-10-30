(* Lexer for Korean Language Server *)

open Ast

type token =
  | Keyword of string
  | Identifier of string
  | NumberLiteral of int
  | StringLiteral of string
  | LeftParen
  | RightParen
  | LeftBrace
  | RightBrace
  | Comma
  | Equals
  | Newline
  | EOF
[@@deriving show]

type token_with_pos = { token: token; pos: position; end_pos: position }

(* Korean keywords *)
let korean_keywords = ["함수"; "변수"; "반환"; "만약"; "아니면"; "반복"; "동안"; "참"; "거짓"]

let is_keyword s = List.mem s korean_keywords

(* Character classification *)
let is_whitespace = function
  | ' ' | '\t' | '\r' -> true
  | _ -> false

let is_digit = function
  | '0' .. '9' -> true
  | _ -> false

let is_alpha = function
  | 'a' .. 'z' | 'A' .. 'Z' | '_' -> true
  | _ -> false

let is_hangul c =
  let code = Char.code c in
  (code >= 0xAC00 && code <= 0xD7A3) (* Hangul syllables *)
  || (code >= 0x1100 && code <= 0x11FF) (* Hangul Jamo *)
  || (code >= 0x3130 && code <= 0x318F) (* Hangul Compatibility Jamo *)
  || (code >= 0xA960 && code <= 0xA97F) (* Hangul Jamo Extended-A *)
  || (code >= 0xD7B0 && code <= 0xD7FF)
(* Hangul Jamo Extended-B *)

let is_identifier_start c = is_alpha c || is_hangul c

let is_identifier_char c = is_alpha c || is_digit c || is_hangul c

(* Lexer state *)
type lexer_state =
  { input: string;
    mutable pos: int;
    mutable line: int;
    mutable character: int
  }

let create_state input = { input; pos= 0; line= 0; character= 0 }

let current_position state = { line= state.line; character= state.character }

let peek state =
  if state.pos >= String.length state.input then None
  else Some (String.get state.input state.pos)

let advance state =
  match peek state with
  | None -> ()
  | Some c ->
      state.pos <- state.pos + 1;
      if c = '\n' then (
        state.line <- state.line + 1;
        state.character <- 0 )
      else state.character <- state.character + 1

let skip_whitespace state =
  let rec loop () =
    match peek state with
    | Some c when is_whitespace c -> advance state; loop ()
    | _ -> ()
  in
  loop ()

let read_number state =
  let start_pos = current_position state in
  let buf = Buffer.create 16 in
  let rec loop () =
    match peek state with
    | Some c when is_digit c -> Buffer.add_char buf c; advance state; loop ()
    | _ -> ()
  in
  loop ();
  let num_str = Buffer.contents buf in
  let num = int_of_string num_str in
  { token= NumberLiteral num;
    pos= start_pos;
    end_pos= current_position state
  }

let read_string state =
  let start_pos = current_position state in
  advance state;
  (* skip opening quote *)
  let buf = Buffer.create 64 in
  let rec loop () =
    match peek state with
    | None -> ()
    | Some '"' -> advance state; ()
    | Some '\\' -> (
        advance state;
        match peek state with
        | Some c -> Buffer.add_char buf c; advance state; loop ()
        | None -> () )
    | Some c -> Buffer.add_char buf c; advance state; loop ()
  in
  loop ();
  { token= StringLiteral (Buffer.contents buf);
    pos= start_pos;
    end_pos= current_position state
  }

let read_identifier state =
  let start_pos = current_position state in
  let buf = Buffer.create 32 in
  let rec loop () =
    match peek state with
    | Some c when is_identifier_char c ->
        Buffer.add_char buf c; advance state; loop ()
    | _ -> ()
  in
  loop ();
  let id = Buffer.contents buf in
  let token = if is_keyword id then Keyword id else Identifier id in
  { token; pos= start_pos; end_pos= current_position state }

let next_token state =
  skip_whitespace state;
  let start_pos = current_position state in
  match peek state with
  | None -> { token= EOF; pos= start_pos; end_pos= start_pos }
  | Some '\n' ->
      advance state;
      { token= Newline; pos= start_pos; end_pos= current_position state }
  | Some '(' ->
      advance state;
      { token= LeftParen; pos= start_pos; end_pos= current_position state }
  | Some ')' ->
      advance state;
      { token= RightParen; pos= start_pos; end_pos= current_position state }
  | Some '{' ->
      advance state;
      { token= LeftBrace; pos= start_pos; end_pos= current_position state }
  | Some '}' ->
      advance state;
      { token= RightBrace; pos= start_pos; end_pos= current_position state }
  | Some ',' ->
      advance state;
      { token= Comma; pos= start_pos; end_pos= current_position state }
  | Some '=' ->
      advance state;
      { token= Equals; pos= start_pos; end_pos= current_position state }
  | Some '"' -> read_string state
  | Some c when is_digit c -> read_number state
  | Some c when is_identifier_start c -> read_identifier state
  | Some c ->
      advance state;
      { token= Identifier (String.make 1 c);
        pos= start_pos;
        end_pos= current_position state
      }

let tokenize input =
  let state = create_state input in
  let rec loop acc =
    let tok = next_token state in
    match tok.token with
    | EOF -> List.rev (tok :: acc)
    | _ -> loop (tok :: acc)
  in
  loop []
