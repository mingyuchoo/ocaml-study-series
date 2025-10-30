(* Logger module for Korean Language Server *)

(* Log level enumeration *)
type log_level = Debug | Info | Warning | Error

(* Logger type with level and output channel *)
type t = { level: log_level; output: out_channel }

(* Convert log level to string *)
let string_of_level = function
  | Debug -> "DEBUG"
  | Info -> "INFO"
  | Warning -> "WARNING"
  | Error -> "ERROR"

(* Convert log level to integer for comparison *)
let int_of_level = function
  | Debug -> 0
  | Info -> 1
  | Warning -> 2
  | Error -> 3

(* Check if a message should be logged based on level *)
let should_log logger msg_level =
  int_of_level msg_level >= int_of_level logger.level

(* Get current timestamp as string *)
let get_timestamp () =
  let open Unix in
  let tm = localtime (time ()) in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d" (tm.tm_year + 1900)
    (tm.tm_mon + 1) tm.tm_mday tm.tm_hour tm.tm_min tm.tm_sec

(* Create a new logger with specified level and log file path *)
let create level log_path =
  try
    let output =
      open_out_gen
        [Open_wronly; Open_creat; Open_append; Open_text]
        0o644 log_path
    in
    { level; output }
  with Sys_error msg ->
    (* Fallback to stderr if file cannot be opened *)
    Printf.eprintf "Warning: Could not open log file %s: %s. Using stderr.\n"
      log_path msg;
    { level; output= stderr }

(* Generic log function *)
let log logger msg_level message =
  if should_log logger msg_level then (
    let timestamp = get_timestamp () in
    let level_str = string_of_level msg_level in
    Printf.fprintf logger.output "[%s] [%s] %s\n" timestamp level_str message;
    flush logger.output )

(* Helper function for debug level *)
let debug logger message = log logger Debug message

(* Helper function for info level *)
let info logger message = log logger Info message

(* Helper function for warning level *)
let warning logger message = log logger Warning message

(* Helper function for error level *)
let error logger message = log logger Error message

(* Close the logger *)
let close logger =
  if logger.output != stderr && logger.output != stdout then
    close_out logger.output
