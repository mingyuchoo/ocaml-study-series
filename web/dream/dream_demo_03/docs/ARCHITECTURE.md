# 주소록 웹 서비스 - Clean Architecture

## 프로젝트 구조

이 프로젝트는 Clean Architecture 원칙을 따라 4개의 레이어로 구성되어 있습니다:

```
lib/
├── domain.ml          # Domain Layer - 핵심 비즈니스 엔티티 및 인터페이스
├── infrastructure.ml  # Infrastructure Layer - 데이터베이스 구현 (SQLite)
├── application.ml     # Application Layer - 유스케이스/비즈니스 로직
└── presentation.ml    # Presentation Layer - 웹 핸들러 및 HTML 템플릿

bin/
└── main.ml           # 진입점 - 모든 레이어 연결
```

## 레이어 설명

### 1. Domain Layer (`lib/domain.ml`)
- **역할**: 핵심 비즈니스 엔티티와 리포지토리 인터페이스 정의
- **내용**:
  - `address`: 주소 엔티티 (id, name, phone, email, address)
  - `address_input`: 주소 입력 DTO
  - `REPOSITORY`: 리포지토리 인터페이스 (CRUD 메서드 정의)
- **의존성**: 없음 (가장 독립적인 레이어)

### 2. Infrastructure Layer (`lib/infrastructure.ml`)
- **역할**: 데이터베이스 접근 구현
- **내용**:
  - `SqliteRepository`: REPOSITORY 인터페이스의 SQLite 구현
  - Caqti를 사용한 SQL 쿼리 정의 및 실행
- **의존성**: Domain Layer

### 3. Application Layer (`lib/application.ml`)
- **역할**: 비즈니스 로직 및 유스케이스 조율
- **내용**:
  - `AddressService`: 주소록 관련 비즈니스 로직
  - 리포지토리를 사용하여 CRUD 작업 수행
- **의존성**: Domain Layer

### 4. Presentation Layer (`lib/presentation.ml`)
- **역할**: HTTP 요청 처리 및 HTML 응답 생성
- **내용**:
  - `AddressHandlers`: Dream 웹 핸들러
  - HTML 템플릿 렌더링 함수
  - 폼 처리 및 리다이렉션
- **의존성**: Domain Layer, Application Layer

### 5. Main Entry Point (`bin/main.ml`)
- **역할**: 모든 레이어를 연결하고 웹 서버 실행
- **내용**:
  - 의존성 주입 (Service, Handlers 초기화)
  - 라우팅 설정
  - 데이터베이스 초기화

## CRUD 기능

### Create (생성)
- **경로**: `POST /addresses`
- **기능**: 새 주소 추가

### Read (조회)
- **경로**: `GET /addresses`
- **기능**: 모든 주소 목록 조회

### Update (수정)
- **경로**: `GET /addresses/:id/edit` (폼)
- **경로**: `POST /addresses/:id` (제출)
- **기능**: 기존 주소 수정

### Delete (삭제)
- **경로**: `POST /addresses/:id/delete`
- **기능**: 주소 삭제

## 실행 방법

```bash
# 의존성 설치
opam install --deps-only --yes .

# 빌드 및 실행
dune exec dream_demo_03

# 또는
make
```

브라우저에서 http://localhost:8080 접속

## 기술 스택

- **웹 프레임워크**: Dream
- **데이터베이스**: SQLite (Caqti 사용)
- **비동기 처리**: Lwt
- **언어**: OCaml

## Clean Architecture 장점

1. **독립성**: 각 레이어가 명확히 분리되어 있어 변경이 용이
2. **테스트 용이성**: 인터페이스를 통한 의존성 주입으로 모킹 가능
3. **유지보수성**: 비즈니스 로직이 프레임워크와 분리되어 있음
4. **확장성**: 새로운 기능 추가 시 해당 레이어만 수정
