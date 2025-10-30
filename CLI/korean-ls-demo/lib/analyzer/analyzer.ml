(* Semantic Analyzer for Korean Language Server *)

open Ast
open Symbol_table

(* Diagnostic severity *)
type severity = Error | Warning | Information | Hint

(* Diagnostic message *)
type diagnostic = { range: range; severity: severity; message: string }

(* Analysis result *)
type analysis_result = { symbols: symbol list; diagnostics: diagnostic list }

(* Analyzer state *)
type analyzer_state =
  { mutable current_scope: scope; mutable diagnostics: diagnostic list }

(* Create a new analyzer state *)
let create_state () =
  { current_scope= create_root_scope (); diagnostics= [] }

(* Add a diagnostic *)
let add_diagnostic state severity message range =
  let diag = { range; severity; message } in
  state.diagnostics <- diag :: state.diagnostics

(* Enter a new scope *)
let enter_scope state =
  let new_scope = create_scope (Some state.current_scope) in
  state.current_scope <- new_scope;
  new_scope

(* Exit the current scope *)
let exit_scope state =
  match state.current_scope.parent with
  | Some parent -> state.current_scope <- parent
  | None -> ()

(* Analyze expression *)
let rec analyze_expr state expr =
  match expr with
  | Identifier (name, range) -> (
    (* Check if the identifier is defined *)
    match lookup state.current_scope name with
    | Some _ -> ()
    | None ->
        add_diagnostic state Error
          (Printf.sprintf "Undefined variable '%s'" name)
          range )
  | Number (_, _) -> ()
  | String (_, _) -> ()
  | FunctionCall { name; args; range } ->
      (* Check if the function is defined *)
      ( match lookup state.current_scope name with
      | Some symbol -> (
        match symbol.kind with
        | Function -> ()
        | _ ->
            add_diagnostic state Error
              (Printf.sprintf "'%s' is not a function" name)
              range )
      | None ->
          add_diagnostic state Error
            (Printf.sprintf "Undefined function '%s'" name)
            range );
      (* Analyze arguments *)
      List.iter (analyze_expr state) args
  | Assignment { name; value; range } ->
      (* Check if variable is already defined in current scope *)
      ( match lookup_local state.current_scope name with
      | Some symbol ->
          add_diagnostic state Warning
            (Printf.sprintf "Variable '%s' is already defined at line %d"
               name
               (symbol.definition_range.start.line + 1) )
            range
      | None ->
          (* Add the variable to the current scope *)
          let _ = add_symbol state.current_scope name Variable range None in
          () );
      (* Analyze the value expression *)
      analyze_expr state value

(* Analyze statement *)
let rec analyze_stmt state stmt =
  match stmt with
  | Expression expr -> analyze_expr state expr
  | FunctionDef { name; params; body; range } ->
      (* Check if function is already defined in current scope *)
      ( match lookup_local state.current_scope name with
      | Some symbol ->
          add_diagnostic state Error
            (Printf.sprintf "Function '%s' is already defined at line %d"
               name
               (symbol.definition_range.start.line + 1) )
            range
      | None ->
          (* Add the function to the current scope *)
          let _ = add_symbol state.current_scope name Function range None in
          () );
      (* Enter a new scope for the function body *)
      let _ = enter_scope state in
      (* Add parameters to the function scope *)
      List.iter
        (fun param ->
          let param_range = { start= range.start; end_= range.start } in
          let _ =
            add_symbol state.current_scope param Parameter param_range None
          in
          () )
        params;
      (* Analyze the function body *)
      List.iter (analyze_stmt state) body;
      (* Exit the function scope *)
      exit_scope state
  | Return (expr_opt, _) -> (
    (* Analyze the return expression if present *)
    match expr_opt with
    | Some expr -> analyze_expr state expr
    | None -> () )

(* Analyze program *)
let analyze_program program =
  let state = create_state () in
  (* Analyze all statements *)
  List.iter (analyze_stmt state) program;
  (* Collect all symbols from the root scope *)
  let symbols = get_all_symbols state.current_scope in
  (* Return the analysis result *)
  { symbols; diagnostics= List.rev state.diagnostics }

(* Main analyze function *)
let analyze program = analyze_program program
