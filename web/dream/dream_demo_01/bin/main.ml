(* (* STEP 1 - At the beginning *) *)
let () = Dream.run (fun _ -> Dream.html "Good morning, world!")

(* (* STEP 2 - Middleware *) let () = Dream.run (Dream.logger (fun _ ->
   Dream.html "Good morning, world!")) *)

(* (* STEP 3 - Middleware with @@; the standard OCaml operator *) let () =
   Dream.run @@ Dream.logger @@ fun _ -> Dream.html "Good morning, world!" *)

(* (* STEP 4 - Router *) let () = Dream.run @@ Dream.logger @@ Dream.router [
   Dream.get "/" (fun _ -> Dream.html "Good morning, world!"); Dream.get
   "/echo/:word" (fun request -> Dream.html (Dream.param request "word"));
   ] *)

(* (* STEP 5 - Counter *) let count = ref 0 let count_requests inner_handler
   request = count := !count + 1; inner_handler request

   let () = Dream.run @@ Dream.logger @@ count_requests @@ Dream.router [
   Dream.get "/" (fun _ -> Dream.html (Printf.sprintf "Saw %i request(s)!"
   !count)); ] *)

(* (* STEP 6 - Pomise *) (* Add ~(preprocess (pps lwt_ppx))~ to =/bin/dune=
   file *) let successful = ref 0 let failed = ref 0

   let count_requests inner_handler request = try%lwt let%lwt response =
   inner_handler request in successful := !successful + 1; Lwt.return
   response

   with exn -> failed := !failed + 1; raise exn

   let () = Dream.run @@ Dream.logger @@ count_requests @@ Dream.router [
   Dream.get "/fail" (fun _ -> raise (Failure "The Web app failed!"));
   Dream.get "/" (fun _ -> Dream.html (Printf.sprintf "%3i request(s)
   successful<br>%3i request(s) failed" !successful !failed)); ] *)

(* (* STEP 7 - Echo *) (* Add ~(preprocess (pps lwt_ppx))~ to =/bin/dune=
   file *) (* Check with ~curl http://localhost:8080/echo -- data foo~ *) let
   () = Dream.run @@ Dream.logger @@ Dream.router [ Dream.post "/echo" (fun
   request -> let%lwt body = Dream.body request in Dream.respond
   ~headers:["Content-Type", "application/octet-stream"] body); ] *)

(* (* STEP 8 - Template *) *)

(* (* STEP 9 - Debug *) let () = Dream.run
   ~error_handler:Dream.debug_error_handler @@ Dream.logger @@ Dream.router [
   Dream.get "/bad" (fun _ -> Dream.empty `Bad_Request); Dream.get "/fail"
   (fun _ -> raise (Failure "The Web app failed!")); ] *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)

(* (* STEP *) *)
