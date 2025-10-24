# 빠른 시작 가이드

## 5분 안에 시작하기

### 1단계: 의존성 설치 (1분)

```bash
make deps
```

또는:

```bash
opam install --deps-only --yes .
```

### 2단계: 실행 (1분)

```bash
make
```

또는:

```bash
dune build
dune exec dream_demo_03
```

### 3단계: 브라우저에서 확인 (1분)

브라우저를 열고 다음 주소로 이동:

```
http://localhost:8080
```

### 4단계: 주소 추가해보기 (2분)

1. "새 주소 추가" 버튼 클릭
2. 다음 정보 입력:
   - 이름: 홍길동
   - 전화번호: 010-1234-5678
   - 이메일: hong@example.com
   - 주소: 서울시 강남구
3. "저장" 버튼 클릭
4. 목록에서 확인

## 완료! 🎉

이제 주소록 웹 서비스가 실행 중입니다.

## 다음 단계

### 더 많은 기능 시도하기

- 주소 수정: 목록에서 "수정" 링크 클릭
- 주소 삭제: 목록에서 "삭제" 버튼 클릭
- 여러 주소 추가: 다양한 연락처 정보 입력

### 코드 살펴보기

1. **Domain Layer** (`lib/domain.ml`)
   - 주소 엔티티 정의 확인
   - REPOSITORY 인터페이스 이해

2. **Infrastructure Layer** (`lib/infrastructure.ml`)
   - SQLite 쿼리 구현 확인
   - Caqti 사용법 학습

3. **Application Layer** (`lib/application.ml`)
   - 비즈니스 로직 서비스 확인
   - 펑터 패턴 이해

4. **Presentation Layer** (`lib/presentation.ml`)
   - HTTP 핸들러 구현 확인
   - HTML 템플릿 렌더링 학습

### 개발 모드로 실행

코드를 수정하면 자동으로 재빌드되는 개발 모드:

```bash
make dev
```

### 데이터베이스 초기화

처음부터 다시 시작하려면:

```bash
make reset-db
make run
```

## 문제 해결

### 포트가 이미 사용 중

```bash
# 기존 프로세스 종료
pkill -f dream_demo_03

# 다시 실행
make run
```

### 빌드 오류

```bash
# 클린 후 재빌드
make clean
make build
```

### 의존성 오류

```bash
# 의존성 재설치
opam update
make deps
```

## 추가 문서

- `README_KO.md`: 전체 프로젝트 설명
- `ARCHITECTURE.md`: Clean Architecture 상세 설명
- `USAGE.md`: 상세 사용 가이드
- `PROJECT_SUMMARY.md`: 프로젝트 요약
- `ARCHITECTURE_DIAGRAM.txt`: 아키텍처 다이어그램

## 도움이 필요하신가요?

1. 문서를 먼저 확인하세요
2. 코드 주석을 읽어보세요
3. 테스트 스크립트를 실행해보세요: `make test-api`

즐거운 코딩 되세요! 🚀
