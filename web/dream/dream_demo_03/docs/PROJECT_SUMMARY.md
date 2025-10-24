# 프로젝트 요약

## 개요

Dream과 SQLite를 사용하여 Clean Architecture 패턴으로 구현한 주소록 웹 서비스입니다.

## 완성된 기능

### ✅ CRUD 기능
- **Create**: 새 주소 추가
- **Read**: 주소 목록 조회
- **Update**: 기존 주소 수정
- **Delete**: 주소 삭제

### ✅ Clean Architecture 구조
```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                  │
│         (lib/presentation.ml)                    │
│  - HTTP 핸들러                                   │
│  - HTML 템플릿 렌더링                            │
│  - 폼 처리                                       │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│              Application Layer                   │
│         (lib/application.ml)                     │
│  - AddressService                                │
│  - 비즈니스 로직 조율                            │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│              Domain Layer                        │
│         (lib/domain.ml)                          │
│  - address 엔티티                                │
│  - REPOSITORY 인터페이스                         │
└────────────────▲────────────────────────────────┘
                 │
┌────────────────┴────────────────────────────────┐
│           Infrastructure Layer                   │
│         (lib/infrastructure.ml)                  │
│  - SqliteRepository                              │
│  - Caqti를 통한 DB 접근                          │
└─────────────────────────────────────────────────┘
```

## 파일 구조

```
dream_demo_03/
├── lib/
│   ├── domain.ml           # 도메인 엔티티 및 인터페이스
│   ├── infrastructure.ml   # SQLite 리포지토리 구현
│   ├── application.ml      # 비즈니스 로직 서비스
│   ├── presentation.ml     # 웹 핸들러 및 템플릿
│   ├── dream_demo_03.ml    # 모듈 내보내기
│   └── dune                # 라이브러리 빌드 설정
├── bin/
│   ├── main.ml             # 애플리케이션 진입점
│   └── dune                # 실행 파일 빌드 설정
├── test/
│   ├── test_dream_demo_03.ml
│   └── dune
├── public/
│   └── index.html
├── Makefile                # 빌드 및 실행 명령
├── dune-project            # Dune 프로젝트 설정
├── dream_demo_03.opam      # OPAM 패키지 정의
├── db.sqlite               # SQLite 데이터베이스 (런타임 생성)
├── README.md               # 원본 README
├── README_KO.md            # 한국어 README
├── ARCHITECTURE.md         # 아키텍처 문서
├── USAGE.md                # 사용 가이드
├── PROJECT_SUMMARY.md      # 이 파일
└── test_api.sh             # API 테스트 스크립트
```

## 기술 스택

| 구성 요소 | 기술 | 버전 |
|-----------|------|------|
| 언어 | OCaml | 5.3.0+ |
| 웹 프레임워크 | Dream | 1.0.0~alpha8 |
| 데이터베이스 | SQLite | - |
| DB 라이브러리 | Caqti | 2.2.4+ |
| 비동기 | Lwt | 5.9.2+ |
| JSON | ppx_yojson_conv | 0.17.0+ |
| 빌드 도구 | Dune | 3.20+ |

## 주요 특징

### 1. Clean Architecture
- **의존성 규칙 준수**: 외부 레이어가 내부 레이어에 의존
- **인터페이스 분리**: REPOSITORY 인터페이스로 구현 분리
- **의존성 주입**: 펑터를 통한 DI 구현

### 2. 타입 안전성
- OCaml의 강력한 타입 시스템 활용
- Caqti의 타입 안전한 쿼리
- 컴파일 타임 오류 검출

### 3. 보안
- CSRF 보호
- Origin/Referrer 체크
- SQL 인젝션 방지 (파라미터화된 쿼리)
- 세션 관리

### 4. 사용자 경험
- 한국어 UI
- 반응형 디자인
- 삭제 확인 대화상자
- 직관적인 네비게이션

## 실행 방법

### 1. 의존성 설치
```bash
make deps
```

### 2. 빌드 및 실행
```bash
make
```

### 3. 브라우저 접속
```
http://localhost:8080
```

## 테스트

### 자동 테스트
```bash
make test-api
```

### 수동 테스트
1. 브라우저에서 http://localhost:8080 접속
2. "새 주소 추가" 클릭
3. 정보 입력 후 저장
4. 목록에서 확인
5. 수정 및 삭제 테스트

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

## Clean Architecture 레이어별 책임

### Domain Layer
- ✅ 비즈니스 엔티티 정의 (`address`, `address_input`)
- ✅ 리포지토리 인터페이스 정의 (`REPOSITORY`)
- ✅ 외부 의존성 없음

### Infrastructure Layer
- ✅ REPOSITORY 인터페이스 구현
- ✅ SQLite 데이터베이스 접근
- ✅ Caqti를 통한 타입 안전한 쿼리

### Application Layer
- ✅ 비즈니스 로직 조율
- ✅ 유스케이스 구현 (AddressService)
- ✅ 리포지토리를 통한 데이터 접근

### Presentation Layer
- ✅ HTTP 요청/응답 처리
- ✅ HTML 템플릿 렌더링
- ✅ 폼 유효성 검사
- ✅ 라우팅 핸들러

## 확장 가능성

### 쉽게 추가할 수 있는 기능
1. **검색 기능**: Domain에 검색 메서드 추가
2. **페이지네이션**: Presentation 레이어에서 구현
3. **정렬 옵션**: Application 레이어에서 처리
4. **REST API**: 새로운 Presentation 핸들러 추가
5. **다른 DB**: Infrastructure 레이어만 교체

### 아키텍처 장점
- 각 레이어가 독립적으로 테스트 가능
- 비즈니스 로직이 프레임워크와 분리
- 새로운 기능 추가 시 영향 범위 최소화

## 성능 특성

- **비동기 처리**: Lwt를 통한 논블로킹 I/O
- **연결 풀링**: Dream의 SQL 풀 사용
- **세션 캐싱**: 메모리 기반 세션 관리
- **경량 DB**: SQLite로 빠른 로컬 접근

## 문서

- `README_KO.md`: 전체 프로젝트 설명 (한국어)
- `ARCHITECTURE.md`: Clean Architecture 상세 설명
- `USAGE.md`: 사용자 가이드
- `PROJECT_SUMMARY.md`: 이 문서

## 개발 명령어

```bash
make deps        # 의존성 설치
make build       # 빌드
make run         # 실행
make dev         # 개발 모드 (자동 재빌드)
make clean       # 클린
make reset-db    # DB 초기화
make test-api    # API 테스트
make format      # 코드 포맷
make doc         # 문서 생성
```

## 결론

이 프로젝트는 OCaml과 Dream을 사용하여 Clean Architecture 원칙을 따르는 실용적인 웹 애플리케이션을 구현한 예제입니다. 각 레이어가 명확히 분리되어 있어 유지보수와 확장이 용이하며, OCaml의 타입 시스템을 활용하여 안전하고 견고한 코드를 작성했습니다.
