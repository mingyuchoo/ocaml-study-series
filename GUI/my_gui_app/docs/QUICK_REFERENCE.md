# Clean Architecture 빠른 참조 가이드

## 새 기능 추가 시 가이드

### 1. 새로운 도메인 엔티티 추가
**파일**: `lib/domain/types.ml`
```ocaml
type new_entity = {
  field1 : string;
  field2 : int;
}
```

### 2. 새로운 이벤트 추가
**파일**: `lib/domain/events.ml`
```ocaml
type t =
  | InputChanged of string
  | SubmitClicked
  | NewEvent of some_data  (* 추가 *)
```

### 3. 새로운 유스케이스 추가
**파일**: `lib/application/use_cases.ml`
```ocaml
let new_use_case state param =
  (* 비즈니스 로직 *)
  { state with field = new_value }
```

### 4. 새로운 UI 컴포넌트 추가
**파일**: `lib/presentation/window_builder.ml`
```ocaml
let create_new_widget ~packing =
  GButton.button ~label:"New" ~packing ()
```

### 5. 이벤트 핸들러 연결
**파일**: `lib/presentation/app_controller.ml`
```ocaml
widget#connect#clicked ~callback:(fun () ->
  state_ref := Application.Use_cases.new_use_case !state_ref;
  sync_ui_with_state widgets !state_ref
) |> ignore
```

## 레이어별 책임

| 레이어 | 책임 | 의존성 |
|--------|------|--------|
| Domain | 비즈니스 엔티티, 이벤트 정의 | 없음 |
| Application | 유스케이스, 비즈니스 로직 | Domain |
| Infrastructure | 외부 라이브러리 추상화 | lablgtk3 |
| Presentation | UI 구성, 이벤트 처리 | 모든 레이어 |

## 일반적인 작업 흐름

### 사용자 액션 처리
1. Presentation에서 이벤트 감지
2. Infrastructure에서 데이터 가져오기
3. Application 유스케이스 호출
4. Domain 상태 업데이트
5. Presentation에서 UI 동기화
6. Infrastructure로 UI 업데이트

### 상태 변경
1. Domain에서 새 상태 타입 정의
2. Application에서 상태 변경 로직 구현
3. Presentation에서 UI 반영 로직 추가

## 테스트 작성

### Domain 테스트
```ocaml
let test_domain () =
  let state = Domain.Types.initial_state in
  assert (state.field = expected_value)
```

### Application 테스트
```ocaml
let test_use_case () =
  let state = Domain.Types.initial_state in
  let result = Application.Use_cases.some_use_case state param in
  assert (result.field = expected_value)
```

## 명령어

```bash
# 빌드
dune build

# 테스트
dune test

# 실행
dune exec my_gui_app

# 클린 빌드
dune clean && dune build

# 포맷팅
dune build @fmt --auto-promote
```
