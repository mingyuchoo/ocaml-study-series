#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# 0. Parse arguments
# ------------------------------------------------------------
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <project_name> [ocaml_version]"
  echo "   e.g. $0 my_workspace 5.3.0"
  exit 1
fi

WORKSPACE_NAME="$1"
OCAML_VERSION="${2:-5.3.0}"

echo "🚀 Setting up OCaml Dune workspace: $WORKSPACE_NAME"
echo "🧱 OCaml version: $OCAML_VERSION"

# ------------------------------------------------------------
# 1. Install prerequisites
# ------------------------------------------------------------
if ! command -v ocaml &> /dev/null; then
  echo "🧰 Installing OCaml, Dune, Opam..."
  sudo dnf install -y ocaml ocaml-dune opam git
fi

# ------------------------------------------------------------
# 2. Setup opam switch
# ------------------------------------------------------------
if ! opam switch list --short | grep -q "$WORKSPACE_NAME"; then
  echo "🌀 Creating opam switch..."
  opam init -y --disable-sandboxing || true
  opam switch create "$WORKSPACE_NAME" "$OCAML_VERSION"
fi

eval "$(opam env)"

# dune 및 테스트 의존성 설치 (스위치 내부)
if ! command -v dune &> /dev/null; then
  echo "📦 Installing dune and test deps via opam..."
  opam install -y dune alcotest
fi

# ------------------------------------------------------------
# 3. Directory structure
# ------------------------------------------------------------
echo "📁 Creating workspace directories..."
mkdir -p "$WORKSPACE_NAME"/{domain,application,infrastructure,presentation}
cd "$WORKSPACE_NAME"

# ------------------------------------------------------------
# 4. dune-workspace
# ------------------------------------------------------------
cat > dune-workspace <<EOF
(lang dune 3.20)
EOF

# ------------------------------------------------------------
# 5. domain/
# ------------------------------------------------------------
opam exec -- dune init project --kind=library domain

cat > domain/dune <<EOF
(library
 (name domain)
 (libraries))
EOF

cat > domain/lib/domain.ml <<EOF
let greet name = "Hello, " ^ name ^ " from domain!"
EOF

# ------------------------------------------------------------
# 6. infrastructure/
# ------------------------------------------------------------
opam exec -- dune init project --kind=library --libs=domain infrastructure

cat > infrastructure/dune <<EOF
(library
 (name infrastructure)
 (libraries domain))
EOF

cat > infrastructure/lib/infrastructure.ml <<EOF
let connect () = print_endline "Infrastructure connected!"
EOF

# ------------------------------------------------------------
# 7. application/
# ------------------------------------------------------------
opam exec -- dune init project --kind=library --libs=domain application

cat > application/dune <<EOF
(library
 (name application)
 (libraries domain))
EOF

cat > application/lib/application.ml <<EOF
let () = print_endline (Domain.greet "Application Layer")
EOF

# ------------------------------------------------------------
# 8. presentation/
# ------------------------------------------------------------
opam exec -- dune init project --kind=executable --libs=application presentation

cat > presentation/dune <<EOF
EOF

cat > presentation/bin/main.ml <<EOF
let display msg = print_endline ("[UI] " ^ msg)

let () = display "앱 시작"
EOF

# ------------------------------------------------------------
# 9. .ocamlformat files
# ------------------------------------------------------------
echo "🌿 Creating .ocamlformat files..."
cat > .ocamlformat <<EOF
version = 0.28.1
version-check = true
profile = ocamlformat
margin = 77
line-endings = lf
break-separators = after
break-cases = fit-or-vertical
break-infix = fit-or-vertical
space-around-records = true
sequence-style = terminator
doc-comments = before
module-item-spacing = sparse
comment-check = true
wrap-comments = true
EOF

cat > .ocamlformat-ignore <<EOF
**/*.eml.ml
EOF


# ------------------------------------------------------------
# 10. Makefile
# ------------------------------------------------------------
echo "🌿 Initializing Makefile..."
cat > Makefile <<'EOF'
.PHONY: build test

CURRENT_DIR := $(notdir $(CURDIR))

all: switch clean format doc build test run

switch:
	opam switch default
	eval $$(opam env)

install:
	opam update
	opam upgrade

clean:
	opam exec -- dune clean

format:
	opam exec -- dune build @fmt --auto-promote

doc:
	opam exec -- dune build @doc

build:
	opam exec -- dune build @all

test:
	opam exec -- dune runtest -f

utop:
	opam exec -- dune utop

watch:
	opam exec -- dune exec --watch "$(CURRENT_DIR)"

run:
	opam exec -- dune exec presentation
EOF

# ------------------------------------------------------------
# 11. Git setup
# ------------------------------------------------------------
echo "🌿 Initializing Git..."
git init -q

cat > .gitignore <<EOF
*.annot
*.cmo
*.cma
*.cmi
*.a
*.o
*.cmx
*.cmxs
*.cmxa
# ocamlbuild working directory
_build/
# ocamlbuild targets
*.byte
*.native
# oasis generated files
setup.data
setup.log
# Merlin configuring file for Vim and Emacs
.merlin
# Dune generated files
*.install
# Local OPAM switch
_opam/
# Jupyter Notebook
.ipynb_checkpoints/
EOF

git add .
git commit -m "Initial OCaml Dune workspace setup" > /dev/null

# ------------------------------------------------------------
# 12. Build + Test
# ------------------------------------------------------------
echo "🧱 Building the workspace..."
make build

echo "🧪 Running tests..."
make test || echo "⚠️ Tests failed, check output."

echo "✅ Done!"
echo "👉 To run:"
echo "   cd $WORKSPACE_NAME"
echo "   make"
