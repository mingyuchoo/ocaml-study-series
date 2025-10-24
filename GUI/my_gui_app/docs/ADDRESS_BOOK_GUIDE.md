# 주소록 애플리케이션 가이드

## 개요

이 애플리케이션은 SQLite 데이터베이스를 사용하는 GTK 기반 주소록 데스크탑 앱입니다. Clean Architecture 원칙을 따라 구현되었습니다.

## 주요 기능

### 1. 연락처 관리
- **추가**: 새로운 연락처를 데이터베이스에 저장
- **수정**: 기존 연락처 정보 업데이트
- **삭제**: 선택한 연락처 제거
- **조회**: 모든 연락처 목록 표시

### 2. 검색 기능
- 실시간 검색: 입력하는 즉시 결과 필터링
- 다중 필드 검색: 이름, 전화번호, 이메일에서 검색
- 대소문자 구분 없음

### 3. 데이터 영속성
- SQLite 데이터베이스 사용
- 자동 테이블 생성
- 트랜잭션 안전성

## 아키텍처 구조

### Domain Layer (lib/domain/)
**types.ml**: 핵심 비즈니스 엔티티
```ocaml
type contact = {
  id: int option;
  name: string;
  phone: string;
  email: string;
  address: string;
}

type app_state = {
  contacts: contact list;
  selected_contact: contact option;
  name_input: string;
  phone_input: string;
  email_input: string;
  address_input: string;
  search_query: string;
}
```

**events.ml**: 도메인 이벤트
- NameChanged, PhoneChanged, EmailChanged, AddressChanged
- SearchChanged
- AddContact, UpdateContact, DeleteContact
- SelectContact, ClearForm

### Application Layer (lib/application/)
**use_cases.ml**: 비즈니스 로직
- `update_name`, `update_phone`, `update_email`, `update_address`
- `clear_form`: 입력 폼 초기화
- `select_contact`: 연락처 선택 및 폼 채우기
- `filter_contacts`: 검색 쿼리로 연락처 필터링
- `handle_event`: 도메인 이벤트 처리

### Infrastructure Layer (lib/infrastructure/)
**sqlite_adapter.ml**: 데이터베이스 어댑터
- `init_db`: 데이터베이스 초기화 및 테이블 생성
- `get_all_contacts`: 모든 연락처 조회
- `add_contact`: 새 연락처 추가
- `update_contact`: 연락처 수정
- `delete_contact`: 연락처 삭제
- `close_db`: 데이터베이스 연결 종료

**gtk_adapter.ml**: GTK UI 어댑터
- 위젯 타입 정의
- UI 헬퍼 함수들

### Presentation Layer (lib/presentation/)
**window_builder.ml**: UI 컴포넌트 생성
- 메인 윈도우 레이아웃
- 연락처 리스트 뷰 (TreeView)
- 입력 폼 (Entry 위젯들)
- 버튼들 (Add, Update, Delete, Clear)

**app_controller.ml**: 애플리케이션 컨트롤러
- 이벤트 핸들러 설정
- UI와 상태 동기화
- 데이터베이스 작업 조율

## 데이터 흐름

### 연락처 추가 흐름
1. 사용자가 폼에 정보 입력
2. "Add" 버튼 클릭
3. Controller가 입력값 수집
4. SQLite Adapter를 통해 DB에 저장
5. DB에서 최신 연락처 목록 로드
6. UI 업데이트

### 검색 흐름
1. 사용자가 검색창에 텍스트 입력
2. SearchChanged 이벤트 발생
3. Use Case가 상태 업데이트
4. filter_contacts가 필터링된 목록 반환
5. UI에 필터링된 결과 표시

### 연락처 선택 흐름
1. 사용자가 리스트에서 연락처 클릭
2. SelectContact 이벤트 발생
3. Use Case가 선택된 연락처 정보로 폼 채우기
4. UI 업데이트

## 의존성 방향

```
Presentation → Application → Domain
     ↓
Infrastructure
```

- Presentation은 Application과 Infrastructure에 의존
- Application은 Domain에만 의존
- Infrastructure는 Domain에 의존
- Domain은 어떤 레이어에도 의존하지 않음 (순수 비즈니스 로직)

## 테스트 가능성

각 레이어는 독립적으로 테스트 가능:

1. **Domain**: 순수 함수, 외부 의존성 없음
2. **Application**: Domain만 의존, 비즈니스 로직 테스트
3. **Infrastructure**: 어댑터 모킹 가능
4. **Presentation**: 통합 테스트

## 확장 가능성

### 새 필드 추가
1. `domain/types.ml`에 필드 추가
2. `application/use_cases.ml`에 업데이트 함수 추가
3. `infrastructure/sqlite_adapter.ml`에 DB 스키마 수정
4. `presentation/window_builder.ml`에 UI 위젯 추가
5. `presentation/app_controller.ml`에 이벤트 핸들러 추가

### 새 기능 추가
1. `domain/events.ml`에 새 이벤트 정의
2. `application/use_cases.ml`에 유스케이스 구현
3. UI와 연결

## 데이터베이스 스키마

```sql
CREATE TABLE IF NOT EXISTS contacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  address TEXT NOT NULL
)
```

## 실행 방법

```bash
# 빌드
dune build

# 실행
dune exec my_gui_app

# 테스트
dune exec test/test_my_gui_app.exe
```

## 데이터 파일

- `contacts.db`: SQLite 데이터베이스 파일 (실행 디렉토리에 생성됨)
