# 빠른 시작 가이드

## 설치

### 1. 의존성 설치

```bash
# 방법 1: setup 스크립트 사용
./setup.sh

# 방법 2: Make 사용
make deps
make install

# 방법 3: 수동 설치
opam install dream caqti caqti-driver-sqlite3 caqti-lwt lwt yojson --yes
opam install --deps-only --yes . --yes
```

### 2. 빌드

```bash
make build
# 또는
dune build
```

### 3. 실행

```bash
make run
# 또는
dune exec reason_demo_02
```

서버가 http://localhost:8080 에서 시작됩니다.

## 사용법

### 웹 UI

브라우저에서 http://localhost:8080 접속

- **홈페이지**: 모든 연락처 목록 보기
- **새 연락처 추가**: "새 연락처 추가" 버튼 클릭
- **연락처 수정**: 각 연락처의 "수정" 버튼 클릭
- **연락처 삭제**: 각 연락처의 "삭제" 버튼 클릭

### REST API

#### 모든 연락처 조회
```bash
curl http://localhost:8080/api/contacts
```

#### 특정 연락처 조회
```bash
curl http://localhost:8080/api/contacts/1
```

#### 새 연락처 생성
```bash
curl -X POST http://localhost:8080/api/contacts \
  -H "Content-Type: application/json" \
  -d '{
    "name": "홍길동",
    "email": "hong@example.com",
    "phone": "010-1234-5678",
    "address": "서울시 강남구"
  }'
```

## 개발

### 코드 포맷팅
```bash
make format
```

### 테스트 실행
```bash
make test
```

### 문서 생성
```bash
make doc
```

### 빌드 정리
```bash
make clean
```

### REPL 시작
```bash
make utop
```

## 프로젝트 구조

```
├── bin/main.ml                           # 웹 서버 진입점
├── lib/
│   ├── domain/                           # 도메인 계층
│   │   ├── contact.ml                    # Contact 엔티티
│   │   └── contact_repository.ml         # Repository 인터페이스
│   ├── infrastructure/                   # 인프라 계층
│   │   └── sqlite_contact_repository.ml  # SQLite 구현
│   ├── application/                      # 애플리케이션 계층
│   │   └── contact_service.ml            # 비즈니스 로직
│   └── presentation/                     # 프레젠테이션 계층
│       ├── contact_dto.ml                # DTO
│       └── web_handlers.ml               # HTTP 핸들러
└── test/test_reason_demo_02.ml           # 테스트

```

## 데이터베이스

SQLite 데이터베이스 파일: `addressbook.db`

프로젝트 실행 시 자동으로 생성되며, 다음 테이블이 포함됩니다:

```sql
CREATE TABLE contacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL
)
```

## 문제 해결

### 포트가 이미 사용 중인 경우
다른 프로세스가 8080 포트를 사용 중이면 `bin/main.ml`에서 포트 번호를 변경하세요:

```ocaml
Dream.run ~port:3000  (* 8080 대신 3000 사용 *)
```

### 의존성 설치 오류
```bash
opam update
opam upgrade
opam install --deps-only --yes . --yes
```

### 빌드 오류
```bash
dune clean
dune build
```

## 추가 정보

- 아키텍처 상세 설명: [ARCHITECTURE.md](ARCHITECTURE.md)
- 전체 문서: [README.md](README.md)
