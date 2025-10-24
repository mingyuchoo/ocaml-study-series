# Address Book Web Application

A Clean Architecture-based address book web application with SQLite storage, built with OCaml.

## Prerequisites

Make sure you have OCaml and Reason installed:

```shell
# Install OCaml package manager
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
opam init -y
eval $(opam env)

# Install build tools and dependencies
opam install dune ocaml-lsp-server odoc ocamlformat utop dream caqti caqti-driver-sqlite3 lwt yojson
```

## Project Structure (Clean Architecture)

```
├── bin/
│   ├── dune                              # Executable configuration
│   └── main.ml                           # Web server entry point
├── lib/
│   ├── domain/                           # Domain Layer (Entities & Interfaces)
│   │   ├── contact.ml                    # Contact entity
│   │   └── contact_repository.ml         # Repository interface
│   ├── infrastructure/                   # Infrastructure Layer (External services)
│   │   └── sqlite_contact_repository.ml  # SQLite implementation
│   ├── application/                      # Application Layer (Use cases)
│   │   └── contact_service.ml            # Business logic
│   ├── presentation/                     # Presentation Layer (Web/API)
│   │   ├── contact_dto.ml                # Data transfer objects
│   │   └── web_handlers.ml               # HTTP handlers
│   ├── dune                              # Library configuration
│   └── reason_demo_02.ml                 # Library entry point
├── test/
│   ├── dune                              # Test configuration
│   └── test_reason_demo_02.ml
├── dune-project                          # Project configuration
└── Makefile                              # Build automation
```

## Clean Architecture Layers

1. **Domain Layer**: Core business entities and repository interfaces
   - `contact.ml`: Contact entity with validation
   - `contact_repository.ml`: Repository interface (dependency inversion)

2. **Infrastructure Layer**: External dependencies and implementations
   - `sqlite_contact_repository.ml`: SQLite database implementation

3. **Application Layer**: Business logic and use cases
   - `contact_service.ml`: Contact management use cases

4. **Presentation Layer**: User interface and API
   - `web_handlers.ml`: HTTP request handlers (HTML + REST API)
   - `contact_dto.ml`: JSON serialization/deserialization

## Development

### Quick Start

```shell
# Install dependencies
make install
# or
make install --deps-only --yes .

# Build and run
make run
```

### Available Commands

```shell
# Clean build artifacts
make clean

# Format code
make format

# Build documentation
make doc

# Build project
make build

# Run tests
make test

# Start utop REPL
make utop

# Run with file watching
make watch
```

### Manual Commands

```shell
# Clean
opam exec -- dune clean

# Format code
opam exec -- dune build @fmt --auto-promote

# Build documentation
opam exec -- dune build @doc

# Build project
opam exec -- dune build

# Run tests
opam exec -- dune runtest -f

# Execute
opam exec -- dune exec reason_demo_02
```

## Features

- **Web UI**: HTML-based interface for managing contacts (Korean language)
  - List all contacts
  - Add new contact
  - Edit existing contact
  - Delete contact

- **REST API**: JSON API endpoints
  - `GET /api/contacts` - List all contacts
  - `GET /api/contacts/:id` - Get contact by ID
  - `POST /api/contacts` - Create new contact

- **SQLite Storage**: Persistent data storage
- **Clean Architecture**: Separation of concerns with clear layer boundaries
- **Validation**: Email and required field validation

## Usage

After running `make run`, the server will start on http://localhost:8080

- Web UI: http://localhost:8080/
- API: http://localhost:8080/api/contacts

### API Examples

```bash
# List all contacts
curl http://localhost:8080/api/contacts

# Get specific contact
curl http://localhost:8080/api/contacts/1

# Create new contact
curl -X POST http://localhost:8080/api/contacts \
  -H "Content-Type: application/json" \
  -d '{"name":"홍길동","email":"hong@example.com","phone":"010-1234-5678","address":"서울시 강남구"}'
```

## Technologies

- **OCaml**: Programming language
- **Dream**: Web framework for OCaml
- **Caqti**: Database access library
- **SQLite**: Embedded database
- **Lwt**: Asynchronous programming library
- **Yojson**: JSON library

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)**: 빠른 시작 가이드 (한국어)
- **[ARCHITECTURE.md](ARCHITECTURE.md)**: Clean Architecture 설계 상세 설명 (한국어)

## References

- [OCaml Documentation](https://ocaml.org/docs/)
- [Dream Web Framework](https://aantron.github.io/dream/)
- [Dune Build System](https://dune.readthedocs.io/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
