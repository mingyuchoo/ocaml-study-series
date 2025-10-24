# 주소록 웹 서비스

Dream과 SQLite를 사용한 Clean Architecture 기반 주소록 웹 애플리케이션입니다.

## 프로젝트 구조

이 프로젝트는 Clean Architecture 원칙을 따라 4개의 레이어로 구성되어 있습니다:

```
lib/
├── domain.ml          # Domain Layer - 핵심 비즈니스 엔티티 및 인터페이스
├── infrastructure.ml  # Infrastructure Layer - 데이터베이스 구현 (SQLite)
├── application.ml     # Application Layer - 유스케이스/비즈니스 로직
├── presentation.ml    # Presentation Layer - 웹 핸들러 및 HTML 템플릿
└── dream_demo_03.ml   # 모듈 내보내기

bin/
└── main.ml           # 진입점 - 모든 레이어 연결
```

## 기능

### CRUD 작업

1. **Create (생성)** - 새 주소 추가
   - 경로: `GET /addresses/new` (폼)
   - 경로: `POST /addresses` (제출)

2. **Read (조회)** - 주소 목록 조회
   - 경로: `GET /addresses`

3. **Update (수정)** - 기존 주소 수정
   - 경로: `GET /addresses/:id/edit` (폼)
   - 경로: `POST /addresses/:id` (제출)

4. **Delete (삭제)** - 주소 삭제
   - 경로: `POST /addresses/:id/delete`

### 주소 정보 필드

- 이름 (name)
- 전화번호 (phone)
- 이메일 (email)
- 주소 (address)

## 설치 및 실행

### 1. 필수 도구 설치

OCaml과 opam이 설치되어 있어야 합니다.

```bash
# OCaml 및 Dune 설치
opam install ocaml dune

# 프로젝트 의존성 설치
opam install --deps-only --yes .
```

### 2. 프로젝트 빌드

```bash
dune build
```

### 3. 실행

```bash
dune exec dream_demo_03
```

또는 Makefile을 사용:

```bash
make
```

### 4. 접속

브라우저에서 http://localhost:8080 접속

자동으로 http://localhost:8080/addresses 로 리다이렉트됩니다.

## Clean Architecture 레이어 설명

### 1. Domain Layer (`lib/domain.ml`)
- **역할**: 핵심 비즈니스 엔티티와 리포지토리 인터페이스 정의
- **의존성**: 없음 (가장 독립적인 레이어)
- **내용**:
  - `address`: 주소 엔티티
  - `address_input`: 주소 입력 DTO
  - `REPOSITORY`: 리포지토리 인터페이스 (CRUD 메서드 시그니처)

### 2. Infrastructure Layer (`lib/infrastructure.ml`)
- **역할**: 데이터베이스 접근 구현
- **의존성**: Domain Layer
- **내용**:
  - `SqliteRepository`: REPOSITORY 인터페이스의 SQLite 구현
  - Caqti를 사용한 SQL 쿼리 정의 및 실행
  - 타입 안전한 데이터베이스 작업

### 3. Application Layer (`lib/application.ml`)
- **역할**: 비즈니스 로직 및 유스케이스 조율
- **의존성**: Domain Layer
- **내용**:
  - `AddressService`: 주소록 관련 비즈니스 로직
  - 리포지토리를 사용하여 CRUD 작업 수행
  - 펑터를 통한 의존성 주입

### 4. Presentation Layer (`lib/presentation.ml`)
- **역할**: HTTP 요청 처리 및 HTML 응답 생성
- **의존성**: Domain Layer, Application Layer
- **내용**:
  - `AddressHandlers`: Dream 웹 핸들러
  - HTML 템플릿 렌더링 함수
  - 폼 처리, 유효성 검사, 리다이렉션

### 5. Main Entry Point (`bin/main.ml`)
- **역할**: 모든 레이어를 연결하고 웹 서버 실행
- **내용**:
  - 의존성 주입 (Service, Handlers 초기화)
  - 라우팅 설정
  - 데이터베이스 초기화 (addresses 및 dream_session 테이블)
  - 미들웨어 구성

## 기술 스택

- **언어**: OCaml 5.3.0+
- **웹 프레임워크**: Dream 1.0.0~alpha8
- **데이터베이스**: SQLite
- **데이터베이스 라이브러리**: Caqti 2.2.4+
- **비동기 처리**: Lwt 5.9.2+
- **JSON 처리**: ppx_yojson_conv 0.17.0+

## 테스트

간단한 API 테스트 스크립트가 포함되어 있습니다:

```bash
./test_api.sh
```

## Clean Architecture의 장점

1. **독립성**: 각 레이어가 명확히 분리되어 있어 변경이 용이
2. **테스트 용이성**: 인터페이스를 통한 의존성 주입으로 모킹 가능
3. **유지보수성**: 비즈니스 로직이 프레임워크와 분리되어 있음
4. **확장성**: 새로운 기능 추가 시 해당 레이어만 수정
5. **재사용성**: 도메인 로직을 다른 프레젠테이션 레이어에서 재사용 가능

## 데이터베이스 스키마

### addresses 테이블

```sql
CREATE TABLE addresses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  address TEXT NOT NULL
);
```

### dream_session 테이블

```sql
CREATE TABLE dream_session (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  expires_at REAL NOT NULL,
  payload TEXT NOT NULL
);
```

## 보안 기능

- CSRF 보호 (Dream의 `csrf_tag` 사용)
- Origin/Referrer 체크
- SQL 인젝션 방지 (Caqti의 파라미터화된 쿼리)
- 세션 관리

## 참고 자료

- [Dream 공식 문서](https://aantron.github.io/dream/)
- [Dream 예제](https://github.com/aantron/dream/tree/master/example)
- [Caqti 문서](https://github.com/paurkedal/ocaml-caqti)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
