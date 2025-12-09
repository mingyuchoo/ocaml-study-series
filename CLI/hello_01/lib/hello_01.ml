(* 라이브러리 모듈: Hello_01 - 책임: 실행 로직을 제공한다. - 공개 API: run : unit -> unit *)

(* 순수 메시지 함수: 테스트에서 검증하기 쉽도록 분리 *)
let message = "Hello, World!"

(* 실행 함수: 콘솔에 메시지를 출력 *)
let run () = print_endline message
