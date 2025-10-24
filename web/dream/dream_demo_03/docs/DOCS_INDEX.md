# 문서 인덱스

이 프로젝트의 모든 문서를 한눈에 볼 수 있는 가이드입니다.

## 📚 시작하기

### 처음 사용하시나요?

1. **[QUICKSTART.md](QUICKSTART.md)** ⭐ 시작은 여기서!
   - 5분 안에 프로젝트 실행
   - 단계별 가이드
   - 문제 해결 팁

2. **[README_KO.md](README_KO.md)** 📖 전체 개요
   - 프로젝트 소개
   - 기능 설명
   - 설치 및 실행 방법
   - 기술 스택

## 🏗️ 아키텍처 이해하기

### Clean Architecture에 대해 알고 싶으신가요?

3. **[ARCHITECTURE.md](ARCHITECTURE.md)** 🏛️ 아키텍처 상세 설명
   - Clean Architecture 원칙
   - 레이어별 책임
   - 의존성 규칙
   - 확장 가능성

4. **[ARCHITECTURE_DIAGRAM.txt](ARCHITECTURE_DIAGRAM.txt)** 📊 시각적 다이어그램
   - 레이어 구조 다이어그램
   - 의존성 흐름
   - 데이터 흐름
   - 설계 원칙

5. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** 📋 프로젝트 요약
   - 완성된 기능 목록
   - 파일 구조
   - 기술 스택 상세
   - 레이어별 책임 체크리스트

## 🔧 사용 방법

### 실제로 사용하는 방법을 알고 싶으신가요?

6. **[USAGE.md](USAGE.md)** 📱 사용자 가이드
   - 주요 기능 사용법
   - Makefile 명령어
   - 개발 팁
   - API 엔드포인트
   - 문제 해결

## 📁 파일 구조

```
프로젝트 루트/
│
├── 📖 문서 (Documentation)
│   ├── QUICKSTART.md              ⭐ 빠른 시작 (여기서 시작!)
│   ├── README_KO.md               📖 전체 개요
│   ├── ARCHITECTURE.md            🏛️ 아키텍처 설명
│   ├── ARCHITECTURE_DIAGRAM.txt   📊 아키텍처 다이어그램
│   ├── PROJECT_SUMMARY.md         📋 프로젝트 요약
│   ├── USAGE.md                   📱 사용 가이드
│   ├── DOCS_INDEX.md              📚 이 파일
│   └── README.md                  📄 원본 README
│
├── 💻 소스 코드 (Source Code)
│   ├── lib/                       라이브러리 (Clean Architecture 레이어)
│   │   ├── domain.ml              🎯 Domain Layer
│   │   ├── infrastructure.ml      🗄️ Infrastructure Layer
│   │   ├── application.ml         ⚙️ Application Layer
│   │   ├── presentation.ml        🌐 Presentation Layer
│   │   ├── dream_demo_03.ml       📦 모듈 내보내기
│   │   └── dune                   🔧 빌드 설정
│   │
│   └── bin/                       실행 파일
│       ├── main.ml                🚀 진입점
│       └── dune                   🔧 빌드 설정
│
├── 🧪 테스트 (Tests)
│   ├── test/                      단위 테스트
│   └── test_api.sh                API 테스트 스크립트
│
├── 🔨 빌드 및 설정 (Build & Config)
│   ├── Makefile                   빌드 명령어
│   ├── dune-project               Dune 프로젝트 설정
│   ├── dream_demo_03.opam         OPAM 패키지 정의
│   └── .gitignore                 Git 무시 파일
│
└── 🗃️ 데이터 (Data)
    └── db.sqlite                  SQLite 데이터베이스
```

## 🎯 목적별 문서 찾기

### 빠르게 시작하고 싶어요
→ **[QUICKSTART.md](QUICKSTART.md)**

### 전체적인 프로젝트를 이해하고 싶어요
→ **[README_KO.md](README_KO.md)** + **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)**

### Clean Architecture를 배우고 싶어요
→ **[ARCHITECTURE.md](ARCHITECTURE.md)** + **[ARCHITECTURE_DIAGRAM.txt](ARCHITECTURE_DIAGRAM.txt)**

### 기능을 사용하는 방법을 알고 싶어요
→ **[USAGE.md](USAGE.md)**

### 코드를 수정하고 싶어요
→ **[ARCHITECTURE.md](ARCHITECTURE.md)** (레이어 이해) + 소스 코드 주석

### 문제가 발생했어요
→ **[USAGE.md](USAGE.md)** (문제 해결 섹션) + **[QUICKSTART.md](QUICKSTART.md)** (문제 해결)

## 📖 읽는 순서 추천

### 초보자
1. QUICKSTART.md - 실행해보기
2. README_KO.md - 전체 이해하기
3. USAGE.md - 기능 사용해보기
4. ARCHITECTURE.md - 구조 이해하기

### 개발자
1. PROJECT_SUMMARY.md - 빠른 개요
2. ARCHITECTURE.md - 아키텍처 이해
3. ARCHITECTURE_DIAGRAM.txt - 구조 시각화
4. 소스 코드 - 구현 확인

### 아키텍트
1. ARCHITECTURE.md - 설계 원칙
2. ARCHITECTURE_DIAGRAM.txt - 레이어 구조
3. PROJECT_SUMMARY.md - 구현 상세
4. 소스 코드 - 패턴 확인

## 🔍 키워드로 찾기

### Clean Architecture
- ARCHITECTURE.md
- ARCHITECTURE_DIAGRAM.txt
- PROJECT_SUMMARY.md

### CRUD 기능
- README_KO.md
- USAGE.md
- PROJECT_SUMMARY.md

### 설치 및 실행
- QUICKSTART.md
- README_KO.md
- USAGE.md

### 데이터베이스
- ARCHITECTURE.md (Infrastructure Layer)
- PROJECT_SUMMARY.md (데이터베이스 스키마)
- USAGE.md (데이터베이스 관리)

### 문제 해결
- QUICKSTART.md
- USAGE.md

### API 엔드포인트
- USAGE.md
- PROJECT_SUMMARY.md

## 💡 팁

- 모든 문서는 한국어로 작성되어 있습니다
- 코드 주석도 참고하세요
- 실제로 실행해보면서 문서를 읽으면 더 이해가 잘 됩니다
- 궁금한 점이 있으면 관련 문서의 해당 섹션을 찾아보세요

## 🚀 지금 바로 시작하기

```bash
# 1. 의존성 설치
make deps

# 2. 실행
make

# 3. 브라우저에서 http://localhost:8080 접속
```

더 자세한 내용은 **[QUICKSTART.md](QUICKSTART.md)**를 참고하세요!
