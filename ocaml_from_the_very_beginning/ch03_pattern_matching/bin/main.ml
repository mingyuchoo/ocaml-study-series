let () =
  Ch03_pattern_matching.Math.factorial 4 |> string_of_int |> print_endline

let () =
  Ch03_pattern_matching.Math.gcd 100 10 |> string_of_int |> print_endline

let () =
  'a'
  |> Ch03_pattern_matching.Eng.is_vowel
  |> string_of_bool
  |> print_endline
