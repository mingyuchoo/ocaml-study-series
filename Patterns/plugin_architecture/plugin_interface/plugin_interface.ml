(* Plugin interface module type definition *)
module type PLUGIN = sig
  val name : unit -> string
  val execute : unit -> unit
end

(* Global registry for plugin registration *)
let plugin_registry : (module PLUGIN) option ref = ref None

let register_plugin plugin_module =
  plugin_registry := Some plugin_module

let get_registered_plugin () =
  !plugin_registry
