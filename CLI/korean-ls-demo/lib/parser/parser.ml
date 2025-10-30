(* Parser for Korean Language Server *)

open Ast
open Lexer

type parser_state =
  { tokens: token_with_pos list;
    mutable pos: int;
    mutable errors: parse_error list
  }

let create_state tokens = { tokens; pos= 0; errors= [] }

let current_token state =
  if state.pos >= List.length state.tokens then
    List.nth state.tokens (List.length state.tokens - 1)
  else List.nth state.tokens state.pos

let peek_token state = (current_token state).token

let advance state =
  if state.pos < List.length state.tokens - 1 then state.pos <- state.pos + 1

let add_error state message range =
  state.errors <- { message; range } :: state.errors

let expect state expected =
  let tok = current_token state in
  match tok.token with
  | t when t = expected -> advance state; true
  | _ ->
      add_error state
        (Printf.sprintf "Expected %s" (show_token expected))
        { start= tok.pos; end_= tok.end_pos };
      false

let make_range start_pos end_pos = { start= start_pos; end_= end_pos }

(* Skip newlines *)
let skip_newlines state =
  let rec loop () =
    match peek_token state with
    | Newline -> advance state; loop ()
    | _ -> ()
  in
  loop ()

(* Parse primary expression *)
let rec parse_primary state =
  let tok = current_token state in
  match tok.token with
  | Identifier id -> (
      advance state;
      skip_newlines state;
      match peek_token state with
      | LeftParen ->
          advance state;
          let args = parse_arguments state in
          let _ = expect state RightParen in
          let end_tok = current_token state in
          Ok
            (FunctionCall
               { name= id; args; range= make_range tok.pos end_tok.end_pos }
            )
      | _ -> Ok (Identifier (id, make_range tok.pos tok.end_pos)) )
  | NumberLiteral n ->
      advance state;
      Ok (Number (n, make_range tok.pos tok.end_pos))
  | StringLiteral s ->
      advance state;
      Ok (String (s, make_range tok.pos tok.end_pos))
  | LeftParen ->
      advance state;
      let expr = parse_expression state in
      let _ = expect state RightParen in
      expr
  | _ ->
      add_error state "Expected expression"
        { start= tok.pos; end_= tok.end_pos };
      Error ()

(* Parse arguments for function call *)
and parse_arguments state =
  skip_newlines state;
  match peek_token state with
  | RightParen -> []
  | _ ->
      let rec loop acc =
        skip_newlines state;
        match parse_expression state with
        | Ok expr -> (
            skip_newlines state;
            match peek_token state with
            | Comma ->
                advance state;
                loop (expr :: acc)
            | _ -> List.rev (expr :: acc) )
        | Error () -> List.rev acc
      in
      loop []

(* Parse expression *)
and parse_expression state =
  skip_newlines state;
  let tok = current_token state in
  match tok.token with
  | Identifier id -> (
      let start_pos = tok.pos in
      advance state;
      skip_newlines state;
      match peek_token state with
      | Equals -> (
          advance state;
          skip_newlines state;
          match parse_expression state with
          | Ok value ->
              let end_tok = current_token state in
              Ok
                (Assignment
                   { name= id;
                     value;
                     range= make_range start_pos end_tok.end_pos
                   } )
          | Error () -> Error () )
      | LeftParen ->
          state.pos <- state.pos - 1;
          parse_primary state
      | _ -> Ok (Identifier (id, make_range tok.pos tok.end_pos)) )
  | _ -> parse_primary state

(* Parse statement *)
let rec parse_statement state =
  skip_newlines state;
  let tok = current_token state in
  match tok.token with
  | Keyword "함수" -> (
      advance state;
      skip_newlines state;
      let name_tok = current_token state in
      match name_tok.token with
      | Identifier name ->
          advance state;
          skip_newlines state;
          let _ = expect state LeftParen in
          let params = parse_parameters state in
          let _ = expect state RightParen in
          skip_newlines state;
          let _ = expect state LeftBrace in
          let body = parse_block state in
          let _ = expect state RightBrace in
          let end_tok = current_token state in
          Ok
            (FunctionDef
               { name;
                 params;
                 body;
                 range= make_range tok.pos end_tok.end_pos
               } )
      | _ ->
          add_error state "Expected function name"
            { start= name_tok.pos; end_= name_tok.end_pos };
          Error () )
  | Keyword "반환" -> (
      advance state;
      skip_newlines state;
      let start_pos = tok.pos in
      match peek_token state with
      | Newline | RightBrace | EOF ->
          let end_tok = current_token state in
          Ok (Return (None, make_range start_pos end_tok.end_pos))
      | _ -> (
        match parse_expression state with
        | Ok expr ->
            let end_tok = current_token state in
            Ok (Return (Some expr, make_range start_pos end_tok.end_pos))
        | Error () -> Error () ) )
  | EOF -> Error ()
  | _ -> (
    match parse_expression state with
    | Ok expr -> Ok (Expression expr)
    | Error () -> Error () )

(* Parse function parameters *)
and parse_parameters state =
  skip_newlines state;
  match peek_token state with
  | RightParen -> []
  | _ ->
      let rec loop acc =
        skip_newlines state;
        let tok = current_token state in
        match tok.token with
        | Identifier id -> (
            advance state;
            skip_newlines state;
            match peek_token state with
            | Comma ->
                advance state;
                loop (id :: acc)
            | _ -> List.rev (id :: acc) )
        | _ -> List.rev acc
      in
      loop []

(* Parse block of statements *)
and parse_block state =
  skip_newlines state;
  let rec loop acc =
    skip_newlines state;
    match peek_token state with
    | RightBrace | EOF -> List.rev acc
    | _ -> (
      match parse_statement state with
      | Ok stmt ->
          skip_newlines state;
          loop (stmt :: acc)
      | Error () -> advance state; loop acc )
  in
  loop []

(* Parse program *)
let parse_program state =
  skip_newlines state;
  let rec loop acc =
    skip_newlines state;
    match peek_token state with
    | EOF -> List.rev acc
    | _ -> (
      match parse_statement state with
      | Ok stmt ->
          skip_newlines state;
          loop (stmt :: acc)
      | Error () -> advance state; loop acc )
  in
  loop []

(* Main parse function *)
let parse input =
  let tokens = tokenize input in
  let state = create_state tokens in
  let program = parse_program state in
  if List.length state.errors > 0 then Error (List.rev state.errors)
  else Ok program
