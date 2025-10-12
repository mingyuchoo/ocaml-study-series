(* Opium 애플리케이션 구성 및 실행 *)

open Opium

let run () =
  App.empty
  |> App.post "/hello/stream" Handlers.streaming_handler
  |> App.get "/hello/:name" Handlers.print_param_handler
  |> App.get "/person/:name/:age" Handlers.print_person_handler
  |> App.patch "/person" Handlers.update_person_handler
  |> App.port 8000
  |> App.run_command
