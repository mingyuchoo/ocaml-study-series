# 사용 가이드

## 빠른 시작

### 1. 프로젝트 실행

```bash
# 빌드 및 실행
make

# 또는 개별 명령
dune build
dune exec dream_demo_03
```

### 2. 웹 브라우저에서 접속

http://localhost:8080

## 주요 기능 사용법

### 주소 추가하기

1. 메인 페이지에서 "새 주소 추가" 버튼 클릭
2. 폼에 정보 입력:
   - 이름
   - 전화번호
   - 이메일
   - 주소
3. "저장" 버튼 클릭

### 주소 수정하기

1. 주소 목록에서 수정하려는 항목의 "수정" 링크 클릭
2. 폼에서 정보 수정
3. "저장" 버튼 클릭

### 주소 삭제하기

1. 주소 목록에서 삭제하려는 항목의 "삭제" 버튼 클릭
2. 확인 대화상자에서 "확인" 클릭

### 주소 목록 보기

- 메인 페이지 (http://localhost:8080/addresses)에서 모든 주소를 이름순으로 정렬하여 표시

## Makefile 명령어

```bash
# 전체 빌드 및 실행
make

# 의존성 설치
make deps

# 빌드만
make build

# 실행만
make run

# 개발 모드 (자동 재빌드)
make dev

# 클린 (빌드 파일 및 DB 삭제)
make clean

# 데이터베이스 초기화
make reset-db

# API 테스트
make test-api

# 코드 포맷
make format

# 문서 생성
make doc
```

## 개발 팁

### 데이터베이스 위치

- SQLite 데이터베이스 파일: `db.sqlite`
- 프로젝트 루트 디렉토리에 생성됨

### 데이터베이스 직접 조회

```bash
sqlite3 db.sqlite "SELECT * FROM addresses;"
```

### 로그 확인

서버 실행 시 콘솔에 모든 HTTP 요청과 응답이 로깅됩니다:
- 요청 메서드 및 경로
- 응답 상태 코드
- 처리 시간 (마이크로초)

### 포트 변경

`bin/main.ml`에서 `Dream.run` 호출 시 `~port` 파라미터 추가:

```ocaml
Dream.run ~port:3000
```

## 문제 해결

### 포트가 이미 사용 중인 경우

```bash
# 8080 포트를 사용하는 프로세스 찾기
lsof -i :8080

# 프로세스 종료
kill -9 <PID>
```

### 데이터베이스 오류

```bash
# 데이터베이스 초기화
make reset-db

# 다시 실행
make run
```

### 빌드 오류

```bash
# 클린 후 재빌드
make clean
make build
```

## API 엔드포인트

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/` | 메인 페이지로 리다이렉트 |
| GET | `/addresses` | 주소 목록 조회 |
| GET | `/addresses/new` | 새 주소 추가 폼 |
| POST | `/addresses` | 새 주소 생성 |
| GET | `/addresses/:id/edit` | 주소 수정 폼 |
| POST | `/addresses/:id` | 주소 업데이트 |
| POST | `/addresses/:id/delete` | 주소 삭제 |

## 보안 참고사항

- 모든 POST 요청은 CSRF 토큰이 필요합니다
- 세션은 SQLite에 저장됩니다
- Origin/Referrer 체크가 활성화되어 있습니다
