open Printf
open Lib

let () =
  let (x, y) = Core.make_vector (1.0, 1.0) (2.0, 2.0) in printf "(%f, %f)\n" x y;
  let (x) = Core.vector_length (3.0, 3.0) in printf "%f\n" x;
  let (x, y) = Core.offset_point (3.0, 3.0) (4.0, 4.0) in printf "(%f, %f)\n" x y;
  let (x, y) = Core.scale_to_length 10.0 (5.0, 5.0) in printf "(%f, %f)\n" x y;
