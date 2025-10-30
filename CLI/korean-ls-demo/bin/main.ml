(* Korean Language Server Main Entry Point *)

(* Open library modules - note: lib uses include_subdirs unqualified *)
module Types = Korean_ls_demo.Types
module Protocol = Korean_ls_demo.Protocol
module Manager = Korean_ls_demo.Manager
module Parser = Korean_ls_demo.Parser
module Analyzer = Korean_ls_demo.Analyzer
module Completion = Korean_ls_demo.Completion
module Hover = Korean_ls_demo.Hover
module Definition = Korean_ls_demo.Definition
module Logger = Korean_ls_demo.Logger
module Symbol_table = Korean_ls_demo.Symbol_table
module Ast = Korean_ls_demo.Ast
open Types
open Protocol

(* Global state *)
type server_state =
  { mutable initialized: bool;
    doc_manager: Manager.t;
    logger: Logger.t;
    scopes: (string, Symbol_table.scope) Hashtbl.t
  }

(* Create initial server state *)
let create_state () =
  let log_path = "/tmp/korean-ls.log" in
  let logger = Logger.create Logger.Info log_path in
  Logger.info logger "Korean Language Server starting...";
  { initialized= false;
    doc_manager= Manager.create ();
    logger;
    scopes= Hashtbl.create 16
  }

(* Global server state *)
let state = create_state ()

(* Helper: Extract string from JSON *)
let get_string json key =
  try Some (Yojson.Safe.Util.member key json |> Yojson.Safe.Util.to_string)
  with _ -> None

(* Helper: Extract int from JSON *)
let get_int json key =
  try Some (Yojson.Safe.Util.member key json |> Yojson.Safe.Util.to_int)
  with _ -> None

(* Helper: Extract position from JSON *)
let get_position json =
  try
    let line =
      Yojson.Safe.Util.member "line" json |> Yojson.Safe.Util.to_int
    in
    let character =
      Yojson.Safe.Util.member "character" json |> Yojson.Safe.Util.to_int
    in
    Some { line; character }
  with _ -> None

(* 10.1: Initialize handler *)
let handle_initialize _params =
  Logger.info state.logger "Handling initialize request";
  state.initialized <- true;
  (* Build server capabilities *)
  let capabilities =
    { text_document_sync= Some 1;
      (* Full sync *)
      completion_provider=
        Some
          (`Assoc
             [ ("resolveProvider", `Bool false);
               ("triggerCharacters", `List [`String "."; `String "("]) ] );
      hover_provider= Some true;
      definition_provider= Some true
    }
  in
  let result = { capabilities } in
  Logger.info state.logger "Server initialized successfully";
  initialize_result_to_yojson result

(* Helper: Parse and analyze document *)
let parse_and_analyze uri content =
  Logger.debug state.logger (Printf.sprintf "Parsing document: %s" uri);
  match Parser.parse content with
  | Ok program ->
      Logger.debug state.logger "Parse successful, running analysis";
      let analysis = Analyzer.analyze program in
      (* Store the scope for this document *)
      let root_scope = Symbol_table.create_root_scope () in
      (* Build scope from symbols *)
      List.iter
        (fun (symbol : Symbol_table.symbol) ->
          let _ =
            Symbol_table.add_symbol root_scope symbol.name symbol.kind
              symbol.definition_range symbol.type_
          in
          () )
        analysis.symbols;
      Hashtbl.replace state.scopes uri root_scope;
      Logger.debug state.logger
        (Printf.sprintf "Found %d diagnostics"
           (List.length analysis.diagnostics) );
      Some analysis
  | Error parse_errors ->
      Logger.debug state.logger
        (Printf.sprintf "Parse failed with %d errors"
           (List.length parse_errors) );
      (* Convert parse errors to analyzer diagnostics *)
      let diagnostics =
        List.map
          (fun (err : Ast.parse_error) ->
            { Analyzer.range= err.range;
              severity= Analyzer.Error;
              message= err.message
            } )
          parse_errors
      in
      Some { Analyzer.symbols= []; diagnostics }

(* Helper: Convert analyzer diagnostic to LSP diagnostic *)
let analyzer_diagnostic_to_lsp (diag : Analyzer.diagnostic) : diagnostic =
  let severity =
    match diag.severity with
    | Analyzer.Error -> Some Error
    | Analyzer.Warning -> Some Warning
    | Analyzer.Information -> Some Information
    | Analyzer.Hint -> Some Hint
  in
  { range=
      { start=
          { line= diag.range.start.line;
            character= diag.range.start.character
          };
        end_=
          { line= diag.range.end_.line;
            character= diag.range.end_.character
          }
      };
    severity;
    code= None;
    source= Some "analyzer";
    message= diag.message
  }

(* 10.3: Publish diagnostics *)
let publish_diagnostics uri diagnostics =
  Logger.debug state.logger
    (Printf.sprintf "Publishing %d diagnostics for %s"
       (List.length diagnostics) uri );
  let lsp_diagnostics = List.map analyzer_diagnostic_to_lsp diagnostics in
  let params =
    `Assoc
      [ ("uri", `String uri);
        ("diagnostics", `List (List.map diagnostic_to_yojson lsp_diagnostics))
      ]
  in
  let notification =
    make_notification "textDocument/publishDiagnostics" params
  in
  write_message notification

(* 10.2: Handle textDocument/didOpen *)
let handle_did_open params =
  Logger.info state.logger "Handling textDocument/didOpen";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    match
      ( get_string text_document "uri",
        get_int text_document "version",
        get_string text_document "text" )
    with
    | Some uri, Some version, Some text ->
        Logger.debug state.logger
          (Printf.sprintf "Opening document: %s (version %d)" uri version);
        Manager.open_document state.doc_manager ~uri ~version ~content:text;
        (* Parse and analyze the document *)
        ( match parse_and_analyze uri text with
        | Some analysis -> publish_diagnostics uri analysis.diagnostics
        | None -> () );
        Logger.info state.logger "Document opened successfully"
    | _ -> Logger.error state.logger "Invalid didOpen parameters"
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in didOpen: %s" (Printexc.to_string e))

(* 10.2: Handle textDocument/didChange *)
let handle_did_change params =
  Logger.info state.logger "Handling textDocument/didChange";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    let content_changes =
      Yojson.Safe.Util.member "contentChanges" params
      |> Yojson.Safe.Util.to_list
    in
    match
      (get_string text_document "uri", get_int text_document "version")
    with
    | Some uri, Some version -> (
        Logger.debug state.logger
          (Printf.sprintf "Updating document: %s (version %d)" uri version);
        (* Get the new text from the first change (full sync) *)
        match content_changes with
        | change :: _ -> (
          match get_string change "text" with
          | Some text ->
              Manager.update_document state.doc_manager ~uri ~version
                ~content:text;
              (* Parse and analyze the updated document *)
              ( match parse_and_analyze uri text with
              | Some analysis -> publish_diagnostics uri analysis.diagnostics
              | None -> () );
              Logger.info state.logger "Document updated successfully"
          | None -> Logger.error state.logger "No text in content change" )
        | [] -> Logger.error state.logger "No content changes provided" )
    | _ -> Logger.error state.logger "Invalid didChange parameters"
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in didChange: %s" (Printexc.to_string e))

(* 10.2: Handle textDocument/didClose *)
let handle_did_close params =
  Logger.info state.logger "Handling textDocument/didClose";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    match get_string text_document "uri" with
    | Some uri ->
        Logger.debug state.logger (Printf.sprintf "Closing document: %s" uri);
        Manager.close_document state.doc_manager ~uri;
        Hashtbl.remove state.scopes uri;
        Logger.info state.logger "Document closed successfully"
    | None -> Logger.error state.logger "Invalid didClose parameters"
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in didClose: %s" (Printexc.to_string e))

(* 10.4: Handle textDocument/completion *)
let handle_completion params =
  Logger.info state.logger "Handling textDocument/completion";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    let position_json = Yojson.Safe.Util.member "position" params in
    match (get_string text_document "uri", get_position position_json) with
    | Some uri, Some position -> (
        Logger.debug state.logger
          (Printf.sprintf "Completion at %s:%d:%d" uri position.line
             position.character );
        match Manager.get_document state.doc_manager ~uri with
        | Some doc ->
            let scope =
              Hashtbl.find_opt state.scopes uri
              |> Option.value ~default:(Symbol_table.create_root_scope ())
            in
            let items = Completion.provide_completion doc position scope in
            let completion_list = Completion.create_completion_list items in
            Logger.debug state.logger
              (Printf.sprintf "Returning %d completion items"
                 (List.length items) );
            completion_list_to_yojson completion_list
        | None ->
            Logger.warning state.logger
              (Printf.sprintf "Document not found: %s" uri);
            completion_list_to_yojson { is_incomplete= false; items= [] } )
    | _ ->
        Logger.error state.logger "Invalid completion parameters";
        completion_list_to_yojson { is_incomplete= false; items= [] }
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in completion: %s" (Printexc.to_string e));
    completion_list_to_yojson { is_incomplete= false; items= [] }

(* 10.4: Handle textDocument/hover *)
let handle_hover params =
  Logger.info state.logger "Handling textDocument/hover";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    let position_json = Yojson.Safe.Util.member "position" params in
    match (get_string text_document "uri", get_position position_json) with
    | Some uri, Some position -> (
        Logger.debug state.logger
          (Printf.sprintf "Hover at %s:%d:%d" uri position.line
             position.character );
        match Manager.get_document state.doc_manager ~uri with
        | Some doc -> (
            let scope =
              Hashtbl.find_opt state.scopes uri
              |> Option.value ~default:(Symbol_table.create_root_scope ())
            in
            match Hover.provide_hover doc position scope with
            | Some hover_result ->
                Logger.debug state.logger "Returning hover information";
                hover_to_yojson hover_result
            | None ->
                Logger.debug state.logger "No hover information available";
                `Null )
        | None ->
            Logger.warning state.logger
              (Printf.sprintf "Document not found: %s" uri);
            `Null )
    | _ ->
        Logger.error state.logger "Invalid hover parameters";
        `Null
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in hover: %s" (Printexc.to_string e));
    `Null

(* 10.4: Handle textDocument/definition *)
let handle_definition params =
  Logger.info state.logger "Handling textDocument/definition";
  try
    let text_document = Yojson.Safe.Util.member "textDocument" params in
    let position_json = Yojson.Safe.Util.member "position" params in
    match (get_string text_document "uri", get_position position_json) with
    | Some uri, Some position -> (
        Logger.debug state.logger
          (Printf.sprintf "Definition at %s:%d:%d" uri position.line
             position.character );
        match Manager.get_document state.doc_manager ~uri with
        | Some doc -> (
            let scope =
              Hashtbl.find_opt state.scopes uri
              |> Option.value ~default:(Symbol_table.create_root_scope ())
            in
            match Definition.provide_definition doc position scope with
            | Some location ->
                Logger.debug state.logger "Returning definition location";
                location_to_yojson location
            | None ->
                Logger.debug state.logger "No definition found";
                `Null )
        | None ->
            Logger.warning state.logger
              (Printf.sprintf "Document not found: %s" uri);
            `Null )
    | _ ->
        Logger.error state.logger "Invalid definition parameters";
        `Null
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error in definition: %s" (Printexc.to_string e));
    `Null

(* Handle shutdown request *)
let handle_shutdown _params =
  Logger.info state.logger "Handling shutdown request";
  `Null

(* Handle exit notification *)
let handle_exit () =
  Logger.info state.logger "Handling exit notification";
  Logger.close state.logger;
  exit 0

(* 10.5: Route requests to appropriate handlers *)
let handle_request id method_ params =
  Logger.debug state.logger
    (Printf.sprintf "Handling request: %s (id=%d)" method_ id);
  try
    let result =
      match method_ with
      | "initialize" -> handle_initialize params
      | "textDocument/completion" ->
          if not state.initialized then
            raise (Failure "Server not initialized")
          else handle_completion params
      | "textDocument/hover" ->
          if not state.initialized then
            raise (Failure "Server not initialized")
          else handle_hover params
      | "textDocument/definition" ->
          if not state.initialized then
            raise (Failure "Server not initialized")
          else handle_definition params
      | "shutdown" -> handle_shutdown params
      | _ ->
          Logger.warning state.logger
            (Printf.sprintf "Unknown method: %s" method_);
          raise (Failure ("Method not found: " ^ method_))
    in
    make_response id result
  with
  | Failure msg ->
      Logger.error state.logger (Printf.sprintf "Request failed: %s" msg);
      make_error_response id MethodNotFound msg
  | e ->
      let error_msg = Printexc.to_string e in
      Logger.error state.logger
        (Printf.sprintf "Internal error: %s" error_msg);
      make_error_response id InternalError error_msg

(* 10.5: Route notifications to appropriate handlers *)
let handle_notification method_ params =
  Logger.debug state.logger
    (Printf.sprintf "Handling notification: %s" method_);
  try
    match method_ with
    | "initialized" -> Logger.info state.logger "Client initialized"
    | "textDocument/didOpen" ->
        if not state.initialized then
          Logger.warning state.logger
            "Received didOpen before initialization"
        else handle_did_open params
    | "textDocument/didChange" ->
        if not state.initialized then
          Logger.warning state.logger
            "Received didChange before initialization"
        else handle_did_change params
    | "textDocument/didClose" ->
        if not state.initialized then
          Logger.warning state.logger
            "Received didClose before initialization"
        else handle_did_close params
    | "exit" -> handle_exit ()
    | _ ->
        Logger.debug state.logger
          (Printf.sprintf "Ignoring notification: %s" method_)
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Error handling notification %s: %s" method_
         (Printexc.to_string e) )

(* 10.5: Main event loop *)
let rec main_loop () =
  match read_message () with
  | None ->
      Logger.info state.logger "No more messages, exiting";
      Logger.close state.logger;
      exit 0
  | Some message ->
      ( match message with
      | Request { id; method_; params } ->
          let params_json = Option.value ~default:`Null params in
          let response = handle_request id method_ params_json in
          write_message response
      | Notification { method_; params } ->
          let params_json = Option.value ~default:`Null params in
          handle_notification method_ params_json
      | Response _ ->
          Logger.warning state.logger "Received unexpected response message"
      );
      main_loop ()

(* Entry point *)
let () =
  try
    Logger.info state.logger "Starting main event loop";
    main_loop ()
  with e ->
    Logger.error state.logger
      (Printf.sprintf "Fatal error: %s" (Printexc.to_string e));
    Logger.close state.logger;
    exit 1
