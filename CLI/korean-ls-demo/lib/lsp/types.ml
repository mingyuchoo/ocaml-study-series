(** LSP Type Definitions *)

(** Position in a text document expressed as zero-based line and character offset *)
type position =
  { line: int; [@key "line"] character: int [@key "character"] }
[@@deriving yojson]

(** A range in a text document expressed as (zero-based) start and end positions *)
type range = { start: position; [@key "start"] end_: position [@key "end"] }
[@@deriving yojson]

(** Represents a location inside a resource, such as a line inside a text file *)
type location = { uri: string; [@key "uri"] range: range [@key "range"] }
[@@deriving yojson]

(** Diagnostic severity *)
type diagnostic_severity =
  | Error [@value 1]
  | Warning [@value 2]
  | Information [@value 3]
  | Hint [@value 4]
[@@deriving yojson]

(** Represents a diagnostic, such as a compiler error or warning *)
type diagnostic =
  { range: range; [@key "range"]
    severity: diagnostic_severity option; [@key "severity"] [@default None]
    code: string option; [@key "code"] [@default None]
    source: string option; [@key "source"] [@default None]
    message: string [@key "message"]
  }
[@@deriving yojson]

(** Text document identifier *)
type text_document_identifier = { uri: string [@key "uri"] }
[@@deriving yojson]

(** Versioned text document identifier *)
type versioned_text_document_identifier =
  { uri: string; [@key "uri"] version: int [@key "version"] }
[@@deriving yojson]

(** Text document item *)
type text_document_item =
  { uri: string; [@key "uri"]
    language_id: string; [@key "languageId"]
    version: int; [@key "version"]
    text: string [@key "text"]
  }
[@@deriving yojson]

(** Text document content change event *)
type text_document_content_change_event =
  { range: range option; [@key "range"] [@default None]
    range_length: int option; [@key "rangeLength"] [@default None]
    text: string [@key "text"]
  }
[@@deriving yojson]

(** Position params for requests that require a position *)
type text_document_position_params =
  { text_document: text_document_identifier; [@key "textDocument"]
    position: position [@key "position"]
  }
[@@deriving yojson]

(** Completion item kind *)
type completion_item_kind =
  | Text [@value 1]
  | Method [@value 2]
  | Function [@value 3]
  | Constructor [@value 4]
  | Field [@value 5]
  | Variable [@value 6]
  | Class [@value 7]
  | Interface [@value 8]
  | Module [@value 9]
  | Property [@value 10]
  | Unit [@value 11]
  | Value [@value 12]
  | Enum [@value 13]
  | Keyword [@value 14]
  | Snippet [@value 15]
  | Color [@value 16]
  | File [@value 17]
  | Reference [@value 18]
[@@deriving yojson]

(** Completion item *)
type completion_item =
  { label: string; [@key "label"]
    kind: completion_item_kind option; [@key "kind"] [@default None]
    detail: string option; [@key "detail"] [@default None]
    documentation: string option; [@key "documentation"] [@default None]
    insert_text: string option [@key "insertText"] [@default None]
  }
[@@deriving yojson]

(** Completion list *)
type completion_list =
  { is_incomplete: bool; [@key "isIncomplete"]
    items: completion_item list [@key "items"]
  }
[@@deriving yojson]

(** Hover contents *)
type markup_content =
  { kind: string; [@key "kind"] (* "plaintext" or "markdown" *)
    value: string [@key "value"]
  }
[@@deriving yojson]

(** Hover result *)
type hover =
  { contents: markup_content; [@key "contents"]
    range: range option [@key "range"] [@default None]
  }
[@@deriving yojson]

(** LSP Error codes *)
type error_code =
  | ParseError [@value -32700]
  | InvalidRequest [@value -32600]
  | MethodNotFound [@value -32601]
  | InvalidParams [@value -32602]
  | InternalError [@value -32603]
  | ServerNotInitialized [@value -32002]
  | UnknownErrorCode [@value -32001]
[@@deriving yojson]

(** Response error *)
type response_error =
  { code: int; [@key "code"]
    message: string; [@key "message"]
    data: Yojson.Safe.t option [@key "data"] [@default None]
  }
[@@deriving yojson]

(** LSP Message types *)
type message =
  | Request of { id: int; method_: string; params: Yojson.Safe.t option }
  | Response of
      { id: int; result: Yojson.Safe.t option; error: response_error option }
  | Notification of { method_: string; params: Yojson.Safe.t option }

(** Server capabilities *)
type server_capabilities =
  { text_document_sync: int option; [@key "textDocumentSync"] [@default None]
    completion_provider: Yojson.Safe.t option;
        [@key "completionProvider"] [@default None]
    hover_provider: bool option; [@key "hoverProvider"] [@default None]
    definition_provider: bool option
        [@key "definitionProvider"] [@default None]
  }
[@@deriving yojson]

(** Initialize result *)
type initialize_result =
  { capabilities: server_capabilities [@key "capabilities"] }
[@@deriving yojson]
