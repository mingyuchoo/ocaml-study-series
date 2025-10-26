(* Hello plugin implementation *)

let name () = "plugin_hello"

let execute () =
  print_endline "Hello, OCaml!"

(* Register with the plugin system *)
let () =
  let module P = struct
    let name = name
    let execute = execute
  end in
  Plugin_interface.register_plugin (module P : Plugin_interface.PLUGIN)
