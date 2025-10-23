# Korean DOCX Parser

DOCX 파일을 Markdown 형식으로 변환하는 OCaml 프로그램입니다.

## 기능

- DOCX 파일의 텍스트 내용 추출
- 단락 구조 유지
- Markdown 형식으로 변환
- 한글 텍스트 완벽 지원

## 요구사항

- OCaml (>= 4.14)
- opam
- camlzip
- xmlm

## 설치

```bash
opam install camlzip xmlm
```

## 빌드

```bash
make build
# 또는
dune build
```

## 사용법

프로그램은 `input/애국가.docx` 파일을 읽어서 `output/애국가.md` 파일로 변환합니다.

```bash
make run
# 또는
dune exec korean-docx-parser
```

## 프로젝트 구조

```
.
├── bin/              # 실행 파일
│   └── main.ml       # 메인 프로그램
├── lib/              # 라이브러리
│   └── korean_docx_parser.ml  # DOCX 파싱 및 변환 로직
├── input/            # 입력 파일
│   └── 애국가.docx
├── output/           # 출력 파일
│   └── 애국가.md
└── test/             # 테스트
    └── test_korean_docx_parser.ml
```

## 작동 원리

1. DOCX 파일을 ZIP으로 열기
2. `word/document.xml` 파일 추출
3. XML 파싱하여 단락(`<w:p>`) 및 텍스트(`<w:t>`) 추출
4. Markdown 형식으로 변환 (단락 사이에 빈 줄 추가)
5. 출력 파일에 저장

## 예제

입력 (애국가.docx):
```
동해물과 백두산이 마르고 닳도록
하느님이 보우하사 우리 나라 만세
무궁화 삼천리 화려강산
대한사람 대한으로 길이 보전하세
```

출력 (애국가.md):
```markdown
동해물과 백두산이 마르고 닳도록

하느님이 보우하사 우리 나라 만세

무궁화 삼천리 화려강산

대한사람 대한으로 길이 보전하세
```

## 라이선스

LICENSE
