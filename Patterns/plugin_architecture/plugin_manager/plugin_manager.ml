(* Plugin Manager - Plugin loader and executor *)

(* Load a plugin from the specified file path *)
let load_plugin plugin_path =
  try
    (* Check if file exists *)
    if not (Sys.file_exists plugin_path) then
      raise (Sys_error (Printf.sprintf "Plugin file not found: %s" plugin_path));
    
    (* Load the plugin dynamically *)
    Dynlink.loadfile plugin_path;
    Printf.printf "Successfully loaded plugin: %s\n" plugin_path
  with
  | Dynlink.Error err ->
      Printf.eprintf "Failed to load plugin: %s\n" (Dynlink.error_message err);
      exit 1
  | Sys_error msg ->
      Printf.eprintf "System error: %s\n" msg;
      exit 1
  | e ->
      Printf.eprintf "Unexpected error: %s\n" (Printexc.to_string e);
      exit 1

(* Execute a plugin module *)
let execute_plugin plugin_module =
  try
    let module P = (val plugin_module : Plugin_interface.PLUGIN) in
    Printf.printf "Executing plugin: %s\n" (P.name ());
    P.execute ();
    Printf.printf "Plugin execution completed successfully\n"
  with
  | e ->
      Printf.eprintf "Error during plugin execution: %s\n" (Printexc.to_string e);
      exit 1

(* Main entry point *)
let () =
  let args = Sys.argv in
  if Array.length args < 2 then begin
    Printf.printf "Usage: %s <plugin_path>\n" args.(0);
    Printf.printf "Example: %s _build/default/plugin_hello/plugin_hello.cmxs\n" args.(0);
    exit 1
  end;
  
  let plugin_path = args.(1) in
  
  (* Load the plugin *)
  load_plugin plugin_path;
  
  (* Get the registered plugin and execute it *)
  match Plugin_interface.get_registered_plugin () with
  | Some plugin_module -> execute_plugin plugin_module
  | None ->
      Printf.eprintf "Plugin did not register itself properly\n";
      exit 1
