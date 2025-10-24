# Address Book - 주소록 데스크탑 앱

OCaml로 작성된 GTK 기반 주소록 데스크탑 애플리케이션입니다. SQLite를 사용하여 연락처 정보를 영구 저장합니다.

## 기능

- **연락처 관리**: 이름, 전화번호, 이메일, 주소 정보 저장
- **CRUD 작업**: 연락처 추가, 수정, 삭제 기능
- **실시간 검색**: 이름, 전화번호, 이메일로 연락처 검색
- **영구 저장**: SQLite 데이터베이스를 통한 데이터 영속성
- **직관적인 UI**: GTK3 기반의 깔끔한 사용자 인터페이스

## 요구사항

- OCaml (5.3 이상)
- Dune (빌드 시스템)
- LablGTK3 (GTK3 바인딩)
- SQLite3 (데이터베이스)

```bash
opam install lablgtk3 sqlite3
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

```
lib/
├── domain/              # 도메인 레이어 (비즈니스 엔티티)
│   ├── types.ml         # 연락처 타입 및 앱 상태
│   └── events.ml        # 도메인 이벤트
├── application/         # 애플리케이션 레이어 (유스케이스)
│   └── use_cases.ml     # 비즈니스 로직 처리
├── infrastructure/      # 인프라 레이어 (외부 의존성)
│   ├── gtk_adapter.ml   # GTK UI 어댑터
│   └── sqlite_adapter.ml # SQLite 데이터베이스 어댑터
└── presentation/        # 프레젠테이션 레이어 (UI)
    ├── window_builder.ml    # UI 컴포넌트 생성
    └── app_controller.ml    # 애플리케이션 컨트롤러

bin/main.ml              # 애플리케이션 진입점
test/test_my_gui_app.ml  # 단위 테스트
```

자세한 아키텍처 설명은 `docs/ARCHITECTURE.md`를 참조하세요.

## 사용 방법

1. 애플리케이션을 실행하면 "Address Book" 창이 열립니다
2. 왼쪽 패널에서 연락처 목록을 확인할 수 있습니다
3. 오른쪽 폼에서 연락처 정보를 입력합니다:
   - Name: 이름
   - Phone: 전화번호
   - Email: 이메일 주소
   - Address: 주소
4. 버튼 기능:
   - **Add**: 새 연락처 추가
   - **Update**: 선택한 연락처 수정
   - **Delete**: 선택한 연락처 삭제
   - **Clear**: 입력 폼 초기화
5. 검색창에 텍스트를 입력하여 연락처를 실시간으로 검색할 수 있습니다
6. 연락처를 클릭하면 상세 정보가 오른쪽 폼에 표시됩니다

## 데이터 저장

연락처 데이터는 `contacts.db` SQLite 데이터베이스 파일에 저장됩니다. 이 파일은 애플리케이션 실행 디렉토리에 자동으로 생성됩니다
