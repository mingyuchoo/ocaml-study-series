(*
 * let isvowel c =
 * match c with
 * | 'a' | 'e' | 'i' | 'o' | 'u' -> true
 * | _ -> false
 * in
 * print_endline (if isvowel 'a' = true then "true" else "false")
 * ;;
 * 
 *)
let is_vowel = function
  | 'a' | 'e' | 'i' | 'o' | 'u' | 'A' | 'E' | 'I' | 'O' | 'U' -> true
  | _ -> false
