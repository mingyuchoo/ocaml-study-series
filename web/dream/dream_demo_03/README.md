# Todo App - OCaml Dream Framework

현대적이고 반응형인 Todo 애플리케이션입니다. OCaml Dream 프레임워크와 SQLite를 사용합니다.

## 기능

- ✅ Todo 항목 추가
- ✅ Todo 완료/미완료 토글
- ✅ Todo 삭제
- ✅ 반응형 UI (모바일/데스크톱)
- ✅ 현대적인 디자인
- ✅ RESTful API
- ✅ Swagger UI를 통한 API 문서 및 테스트

## 설치 및 실행

### 1. 필수 도구 설치

OCaml과 opam 설치:
```shell
opam install ocaml dune
```

필요한 패키지 설치:
```shell
opam install dream caqti-driver-sqlite3 lwt_ppx ppx_yojson_conv
```

### 2. 프로젝트 설정

의존성 설치 및 데이터베이스 초기화:
```shell
make setup
```

또는 수동으로:
```shell
opam install --deps-only --yes .
make init-db
```

### 3. 실행

```shell
make run
```

또는:
```shell
opam exec -- dune exec dream_demo_03
```

### 4. 접속

- Todo 앱: [http://localhost:8080](http://localhost:8080)
- API 문서 (Swagger UI): [http://localhost:8080/api-docs](http://localhost:8080/api-docs)

## API 엔드포인트

### UI
- `GET /` - Todo 앱 UI
- `GET /api-docs` - Swagger UI (API 문서 및 테스트)

### REST API
- `GET /api/todos` - 모든 Todo 조회
- `POST /api/todos` - 새 Todo 추가 (form-data: title)
- `GET /api/todos/:id` - 특정 Todo 조회
- `POST /api/todos/:id/toggle` - Todo 완료 상태 토글
- `DELETE /api/todos/:id` - Todo 삭제

모든 API는 Swagger UI에서 직접 테스트할 수 있습니다.

## 프로젝트 구조

```
.
├── bin/
│   ├── main.eml.ml    # 메인 애플리케이션 (Dream EML 템플릿)
│   └── dune           # 빌드 설정
├── lib/               # 라이브러리 (필요시 확장)
├── public/            # 정적 파일
│   ├── swagger.html   # Swagger UI
│   └── openapi.json   # OpenAPI 3.0 스펙
├── db.sqlite          # SQLite 데이터베이스
├── init_db.sql        # 데이터베이스 스키마
└── Makefile           # 빌드 스크립트

```

## 개발

데이터베이스 초기화:
```shell
make init-db
```

빌드:
```shell
make build
```

클린:
```shell
make clean
```

## 기술 스택

- **Backend**: OCaml + Dream Framework
- **Database**: SQLite + Caqti
- **Frontend**: Vanilla JavaScript + CSS
- **Template**: Dream EML (Embedded ML)

## 참고 자료

- [Dream Framework](https://aantron.github.io/dream/)
- [Dream Examples](https://github.com/aantron/dream/tree/master/example)
- [Caqti Documentation](https://github.com/paurkedal/ocaml-caqti)