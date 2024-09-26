let swap a b =
  let t = !a in
  a := !b;
  b := t

let smallest_pow2 x =
  let t = ref 1 in
  while !t < x do
    t := !t * 2
  done;
  !t
