(* Test for logger module *)

let test_logger () =
  (* Create a logger with Debug level *)
  let logger =
    Korean_ls_demo.Logger.create Korean_ls_demo.Logger.Debug
      "/tmp/korean_ls_test.log"
  in
  (* Test all log levels *)
  Korean_ls_demo.Logger.debug logger "This is a debug message";
  Korean_ls_demo.Logger.info logger "This is an info message";
  Korean_ls_demo.Logger.warning logger "This is a warning message";
  Korean_ls_demo.Logger.error logger "This is an error message";
  (* Close the logger *)
  Korean_ls_demo.Logger.close logger;
  print_endline "Logger test completed successfully"

let () = test_logger ()
