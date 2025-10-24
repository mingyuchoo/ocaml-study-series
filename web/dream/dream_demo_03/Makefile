.PHONY: build test clean install run dev deps

CURRENT_DIR := $(notdir $(CURDIR))

# 기본 타겟: 빌드 및 실행
all: build run

# 의존성 설치
deps:
	opam install --deps-only --yes .

# 전체 설치 (opam 패키지 포함)
install: deps
	opam install dream caqti-driver-sqlite3 lwt_ppx ppx_yojson_conv

# 클린
clean:
	opam exec -- dune clean
	rm -f db.sqlite

# 포맷
format:
	opam exec -- dune build @fmt --auto-promote

# 문서 생성
doc:
	opam exec -- dune build @doc

# 빌드
build:
	opam exec -- dune build

# 테스트
test:
	opam exec -- dune runtest -f

# API 테스트
test-api:
	./test_api.sh

# utop 실행
utop:
	opam exec -- dune utop

# 개발 모드 (watch)
dev:
	opam exec -- dune exec --watch "$(CURRENT_DIR)"

# 실행
run:
	opam exec -- dune exec "$(CURRENT_DIR)"

# 데이터베이스 초기화
reset-db:
	rm -f db.sqlite
	@echo "데이터베이스가 초기화되었습니다. 다음 실행 시 자동으로 생성됩니다."
