let x1 = 200

let x2 =
  let x2 = 200 in
  x2 * x2 * x2

let x3 =
  let x3 = 500 in
  let y3 = x3 * x3 in
  x3 + y3

let cube x = x * x * x

let x4 = cube 200

let neg x =
  if x < 0 then true else false

let x5 = neg (-30)

let isvowel c =
  c = 'a'
  || c = 'e'
  || c = 'i'
  || c = 'o'
  || c = 'u'

let x6 = isvowel 'x'

let addtoten a b = a + b = 10

let x7 = addtoten 6 4

let rec factorial a =
  if a = 1 then 1
  else a * factorial (a - 1)

let x8 = factorial 4

let rec gcd a b =
  if b = 0 then a else gcd b (a mod b)

let x9 = gcd 64000 3456

let not x = if x then false else true

let x10 = not true
