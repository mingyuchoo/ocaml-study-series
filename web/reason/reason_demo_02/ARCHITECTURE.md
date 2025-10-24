# Clean Architecture 설계

이 프로젝트는 Clean Architecture 원칙을 따라 구현된 주소록 관리 웹 애플리케이션입니다.

## 아키텍처 레이어

### 1. Domain Layer (도메인 계층)
**위치**: `lib/domain/`

비즈니스 로직의 핵심이 되는 엔티티와 인터페이스를 정의합니다.

- **contact.ml**: Contact 엔티티
  - 연락처 데이터 구조 정의
  - 비즈니스 규칙 및 검증 로직
  - 외부 의존성 없음

- **contact_repository.ml**: Repository 인터페이스 (시그니처)
  - 데이터 접근 계약 정의
  - 구현체는 Infrastructure 계층에 위치
  - 의존성 역전 원칙(Dependency Inversion Principle) 적용

**특징**:
- 다른 계층에 의존하지 않음
- 순수한 비즈니스 로직만 포함
- 프레임워크나 데이터베이스에 독립적

### 2. Infrastructure Layer (인프라 계층)
**위치**: `lib/infrastructure/`

외부 시스템과의 통신을 담당합니다.

- **sqlite_contact_repository.ml**: SQLite 데이터베이스 구현
  - Contact_repository 인터페이스 구현
  - Caqti 라이브러리를 사용한 데이터베이스 접근
  - SQL 쿼리 및 데이터 변환 처리

**특징**:
- Domain 계층의 인터페이스를 구현
- 데이터베이스, 파일 시스템 등 외부 리소스 접근
- 교체 가능한 구조 (SQLite → PostgreSQL 등)

### 3. Application Layer (애플리케이션 계층)
**위치**: `lib/application/`

비즈니스 유스케이스를 구현합니다.

- **contact_service.ml**: 연락처 관리 유스케이스
  - 연락처 생성, 조회, 수정, 삭제 로직
  - Repository를 통한 데이터 접근
  - 비즈니스 규칙 적용 및 조율

**특징**:
- Domain 계층의 엔티티와 인터페이스 사용
- 비즈니스 흐름 조율
- 트랜잭션 관리

### 4. Presentation Layer (프레젠테이션 계층)
**위치**: `lib/presentation/`

사용자 인터페이스와 API를 제공합니다.

- **web_handlers.ml**: HTTP 요청 핸들러
  - HTML 웹 UI 핸들러
  - REST API 엔드포인트
  - 요청/응답 처리

- **contact_dto.ml**: 데이터 전송 객체
  - JSON 직렬화/역직렬화
  - API 응답 포맷팅

**특징**:
- Application 계층의 서비스 호출
- HTTP 프로토콜 처리
- 사용자 입력 검증 및 변환

## 의존성 방향

```
Presentation → Application → Domain ← Infrastructure
```

- 모든 계층은 Domain을 향해 의존
- Domain은 어떤 계층에도 의존하지 않음
- Infrastructure는 Domain의 인터페이스를 구현

## 의존성 역전 원칙 (Dependency Inversion)

```ocaml
(* Domain: 인터페이스 정의 *)
module type S = sig
  val find_all: unit -> Contact.t list Lwt.t
  ...
end

(* Infrastructure: 구현 *)
module Repo : Contact_repository.S = struct
  let find_all () = (* SQLite 구현 *)
  ...
end

(* Application: 인터페이스에 의존 *)
let get_all_contacts (module Repo : Contact_repository.S) =
  Repo.find_all ()
```

## 장점

1. **테스트 용이성**: 각 계층을 독립적으로 테스트 가능
2. **유지보수성**: 변경 사항이 특정 계층에 국한됨
3. **확장성**: 새로운 기능 추가가 용이
4. **독립성**: 프레임워크, 데이터베이스 교체 가능
5. **명확한 책임**: 각 계층의 역할이 명확히 구분됨

## 데이터 흐름

### 웹 요청 처리 흐름:
```
1. HTTP Request
   ↓
2. Web Handler (Presentation)
   ↓
3. Contact Service (Application)
   ↓
4. Contact Repository Interface (Domain)
   ↓
5. SQLite Repository (Infrastructure)
   ↓
6. Database
```

### 응답 흐름:
```
1. Database
   ↓
2. SQLite Repository (Infrastructure)
   ↓
3. Contact Entity (Domain)
   ↓
4. Contact Service (Application)
   ↓
5. Contact DTO (Presentation)
   ↓
6. HTTP Response
```

## 모듈 구조

```
reason_demo_02 (메인 라이브러리)
├── domain (도메인 계층)
│   ├── Contact
│   └── Contact_repository
├── infrastructure (인프라 계층)
│   └── Sqlite_contact_repository
├── application (애플리케이션 계층)
│   └── Contact_service
└── presentation (프레젠테이션 계층)
    ├── Contact_dto
    └── Web_handlers
```

## 확장 가능성

### 새로운 저장소 추가 (예: PostgreSQL)
```ocaml
(* lib/infrastructure/postgres_contact_repository.ml *)
module Repo : Contact_repository.S = struct
  (* PostgreSQL 구현 *)
end
```

### 새로운 API 추가 (예: GraphQL)
```ocaml
(* lib/presentation/graphql_handlers.ml *)
let schema = (* GraphQL 스키마 정의 *)
```

### 새로운 유스케이스 추가
```ocaml
(* lib/application/contact_search_service.ml *)
let search_contacts repo query = (* 검색 로직 *)
```
