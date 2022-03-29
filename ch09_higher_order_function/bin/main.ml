open Printf
open Lib

let () =
  let result = Core.add1 2 3 in printf "%d\n" result;
  let result = Core.add2 2 3 in printf "%d\n" result;
