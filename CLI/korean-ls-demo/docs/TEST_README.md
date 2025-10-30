# Korean Language Server - Testing Guide

## Quick Start

### 1. Run Automated Integration Tests
```bash
./test_integration.sh
```

This script verifies:
- OCaml server build
- VSCode extension build
- Sample files creation
- Basic server functionality

### 2. Check Server Logs
```bash
./check_logs.sh
```

This script shows:
- Log file location
- Recent log entries
- Instructions for real-time monitoring

### 3. Manual Testing in VSCode

See [INTEGRATION_TEST.md](INTEGRATION_TEST.md) for detailed manual testing instructions.

## Test Files

- `test_sample.kr` - Basic valid Korean code for testing core features
- `test_errors.kr` - Code with intentional errors for diagnostic testing
- `test_completion.kr` - Code for testing auto-completion features

## Build Commands

### Build OCaml Server
```bash
dune build
```

### Build VSCode Extension
```bash
cd vscode-extension
npm run compile
```

### Clean Build
```bash
dune clean
cd vscode-extension
rm -rf out/
```

## Running the Extension

1. Open this workspace in VSCode
2. Press F5 to launch Extension Development Host
3. Open any `.kr` file in the new window
4. Test language features:
   - Syntax highlighting
   - Error diagnostics
   - Auto-completion (Ctrl+Space)
   - Hover information
   - Go to Definition (F12)

## Debugging

### Server-Side Debugging
- Check logs: `~/.korean-ls.log`
- Monitor in real-time: `tail -f ~/.korean-ls.log`
- Increase log level in server code if needed

### Client-Side Debugging
- Open VSCode Output panel (View → Output)
- Select "Korean Language Server" from dropdown
- Check for connection and communication errors

### Common Issues

**Server doesn't start:**
- Verify server path in VSCode settings
- Check executable permissions: `ls -l _build/default/bin/main.exe`
- Review Output panel for error messages

**No language features working:**
- Verify file extension is `.kr`
- Check if server is connected (status bar)
- Try restarting server (Command Palette → "Korean Language Server: Restart")

**Build errors:**
- OCaml: Run `dune clean` then `dune build`
- Extension: Delete `vscode-extension/out/` then run `npm run compile`

## Test Coverage

### Requirements Verified

- ✅ 1.1, 1.2, 1.3, 1.4: Server startup and connection
- ✅ 2.1, 2.2, 2.3, 2.4: Diagnostics and error reporting
- ✅ 3.1, 3.2, 3.3: Auto-completion
- ✅ 4.1, 4.2, 4.3: Hover information
- ✅ 5.1, 5.2, 5.3: Go to definition
- ✅ 6.1, 6.2, 6.3, 6.4: Build and configuration
- ✅ 7.1, 7.2, 7.3, 7.4: Error handling
- ✅ 8.1, 8.2, 8.3, 8.4: Logging

## Next Steps

After successful testing:
1. Package extension: `cd vscode-extension && npm run package`
2. Install locally: `code --install-extension korean-language-server-*.vsix`
3. Test in production VSCode environment
4. Gather user feedback
5. Iterate on improvements
