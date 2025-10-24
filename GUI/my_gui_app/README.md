# my_gui_app

OCaml로 작성된 GTK 기반 GUI 애플리케이션입니다.

## 기능

- **메뉴 바**: File 메뉴와 Quit 옵션 제공
- **텍스트 입력**: 사용자 입력을 받는 텍스트 필드
- **동적 라벨**: 입력된 텍스트를 실시간으로 표시
- **버튼 이벤트**: Submit 버튼 클릭 시 입력 내용 업데이트

## 요구사항

- OCaml (5.3 이상)
- Dune (빌드 시스템)
- LablGTK2 (GTK 바인딩)
- LablGTK3 (GTK3 바인딩)

```bash
opam install lablgtk lablgtk3
opam install --deps-only --yes .
```

## 빌드

```bash
dune build
# or
make build
```

## 실행

```bash
dune exec my_gui_app
# or
make run
```

## 프로젝트 구조

이 프로젝트는 Clean Architecture 패턴을 따릅니다:

- `bin/main.ml`: 애플리케이션 진입점
- `lib/domain/`: 비즈니스 엔티티 및 이벤트
- `lib/application/`: 유스케이스 및 비즈니스 로직
- `lib/infrastructure/`: GTK 어댑터 (외부 의존성)
- `lib/presentation/`: UI 컴포넌트 및 컨트롤러

자세한 아키텍처 설명은 [ARCHITECTURE.md](ARCHITECTURE.md)를 참조하세요.

## 사용 방법

1. 애플리케이션을 실행하면 "OCaml GTK App" 창이 열립니다
2. 텍스트 필드에 원하는 내용을 입력합니다
3. "Submit" 버튼을 클릭하면 입력한 내용이 라벨에 표시됩니다
4. File → Quit 메뉴 또는 창 닫기로 종료할 수 있습니다
