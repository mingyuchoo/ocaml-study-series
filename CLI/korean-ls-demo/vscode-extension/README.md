# Korean Language Server Extension

VSCode extension for the Korean programming language.

## Features

- Syntax highlighting for `.kr` files
- Real-time diagnostics (syntax and semantic errors)
- Code completion
- Hover information
- Go to definition

## Requirements

- Korean Language Server executable (built from the OCaml project)

## Extension Settings

This extension contributes the following settings:

- `koreanLanguageServer.serverPath`: Path to the Korean Language Server executable
- `koreanLanguageServer.logLevel`: Log level for the language server (debug, info, warning, error)
- `koreanLanguageServer.trace.server`: Traces the communication between VS Code and the language server

## Installation

1. Build the OCaml language server: `dune build`
2. Install the extension: `code --install-extension korean-language-server-*.vsix`
3. Configure the server path in VSCode settings

## Development

```bash
# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Watch mode
npm run watch

# Package extension
npm run package
```
