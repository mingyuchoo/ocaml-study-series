# Implementation Plan

- [x] 1. Dune workspace 기본 구조 설정
  - dune-workspace 파일 생성하여 빌드 컨텍스트 정의
  - dune-project 파일 생성하여 프로젝트 메타데이터 설정
  - 프로젝트 루트에 디렉토리 구조 생성 (plugin_interface/, plugin_manager/, plugin_hello/)
  - _Requirements: 5.1, 5.2_

- [x] 2. Plugin interface 라이브러리 구현
  - [x] 2.1 Plugin interface 모듈 타입 정의
    - plugin_interface/plugin_interface.ml 파일 생성
    - PLUGIN module type 정의 (name, execute 함수 시그니처 포함)
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [x] 2.2 Plugin interface dune 설정
    - plugin_interface/dune 파일 생성
    - library 스탠자 설정 (name, modules 지정)
    - _Requirements: 5.3_

- [x] 3. Hello plugin 구현
  - [x] 3.1 Hello plugin 모듈 작성
    - plugin_hello/plugin_hello.ml 파일 생성
    - name 함수 구현 ("plugin_hello" 반환)
    - execute 함수 구현 ("Hello, OCaml!" 출력)
    - Plugin_interface.PLUGIN 인터페이스 구현
    - _Requirements: 4.1, 4.2, 4.3_
  
  - [x] 3.2 Hello plugin dune 설정
    - plugin_hello/dune 파일 생성
    - library 스탠자 설정 (name, modules, libraries, modes plugin)
    - plugin_interface 라이브러리 의존성 추가
    - .cmxs 파일 생성을 위한 modes plugin 설정
    - _Requirements: 4.4, 6.1, 6.2_

- [x] 4. Plugin Manager 구현
  - [x] 4.1 플러그인 로딩 로직 구현
    - plugin_manager/plugin_manager.ml 파일 생성
    - Dynlink.loadfile을 사용한 동적 로딩 함수 작성
    - 파일 존재 여부 확인 로직 추가
    - Dynlink.Error 예외 처리 구현
    - Sys_error 예외 처리 구현
    - _Requirements: 2.1, 2.2, 2.3_
  
  - [x] 4.2 플러그인 실행 로직 구현
    - 로드된 플러그인 모듈을 first-class module로 처리
    - 플러그인의 name() 함수 호출 및 출력
    - 플러그인의 execute() 함수 호출
    - 실행 중 예외 처리 구현
    - _Requirements: 3.1, 3.2, 3.3, 3.4_
  
  - [x] 4.3 메인 함수 및 커맨드 라인 처리
    - 커맨드 라인 인자로 플러그인 경로 받기
    - 인자 검증 (경로 제공 여부 확인)
    - 플러그인 로드 및 실행 오케스트레이션
    - 사용법 메시지 출력 (인자 없을 시)
    - _Requirements: 6.3_
  
  - [x] 4.4 Plugin Manager dune 설정
    - plugin_manager/dune 파일 생성
    - executable 스탠자 설정 (name, modules, libraries)
    - plugin_interface와 dynlink 라이브러리 의존성 추가
    - _Requirements: 5.2_

- [x] 5. 빌드 검증 및 통합
  - [x] 5.1 전체 workspace 빌드
    - dune build 명령으로 모든 컴포넌트 빌드
    - 빌드 에러 확인 및 수정
    - 빌드 아티팩트 위치 확인 (.exe, .cmxs 파일)
    - _Requirements: 5.5, 6.4_
  
  - [x] 5.2 플러그인 로딩 및 실행 테스트
    - plugin_manager 실행 시 plugin_hello.cmxs 경로 전달
    - "Hello, OCaml!" 출력 확인
    - 플러그인 이름 출력 확인
    - _Requirements: 2.1, 3.1, 4.3_
  
  - [x] 5.3 에러 케이스 테스트
    - 존재하지 않는 플러그인 파일 경로로 실행
    - 적절한 에러 메시지 출력 확인
    - 애플리케이션이 정상적으로 종료되는지 확인
    - _Requirements: 2.2, 2.3_

- [x] 6. 문서화
  - [x] 6.1 README 파일 작성
    - README.md 파일 생성
    - 프로젝트 구조 설명 추가
    - 빌드 방법 설명 (dune build)
    - 실행 방법 설명 (dune exec 사용법)
    - 새 플러그인 생성 예제 추가
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
