(** My GUI App - 메인 라이브러리 진입점 *)

module Domain = Domain
module Application = Application
module Infrastructure = Infrastructure
module Presentation = Presentation

(** 애플리케이션 실행 *)
let run = Presentation.App_controller.run
