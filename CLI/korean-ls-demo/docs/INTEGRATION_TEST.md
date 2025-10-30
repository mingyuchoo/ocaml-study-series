# Korean Language Server - Integration Test Guide

## Overview

This document provides a comprehensive guide for testing the Korean Language Server integration with VSCode.

## Quick Start

**For automated testing:**
```bash
./test_integration.sh
```

**For manual testing:**
1. Run automated tests first
2. Press F5 in VSCode to launch Extension Development Host
3. Follow `MANUAL_TEST_CHECKLIST.md`

**Additional Resources:**
- `INTEGRATION_TEST_GUIDE.md` - Complete testing workflow
- `MANUAL_TEST_CHECKLIST.md` - Detailed manual test checklist
- `test_comprehensive.kr` - Comprehensive test file

## Prerequisites

- ✅ OCaml server built successfully (`_build/default/bin/main.exe`)
- ✅ VSCode extension compiled successfully (`vscode-extension/out/`)
- ✅ Sample Korean file created (`test_sample.kr`)

## Build Verification

### OCaml Server Build
```bash
dune build
```
Expected: Build completes without errors
Executable location: `_build/default/bin/main.exe`

### VSCode Extension Build
```bash
cd vscode-extension
npm run compile
```
Expected: TypeScript compilation completes without errors
Output files:
- `vscode-extension/out/extension.js`
- `vscode-extension/out/client.js`
- `vscode-extension/out/configuration.js`

## Manual Integration Testing in VSCode

### Step 1: Launch Extension Development Host

1. Open this workspace in VSCode
2. Open the Run and Debug panel (Ctrl+Shift+D / Cmd+Shift+D)
3. Select "Run Extension" from the dropdown
4. Press F5 or click the green play button
5. A new VSCode window (Extension Development Host) will open

### Step 2: Open Sample Korean File

1. In the Extension Development Host window, open `test_sample.kr`
2. Verify the file opens without errors

### Step 3: Test Language Server Connection

**Expected Behavior:**
- Status bar should show language server connection status
- No error notifications about server startup failure

**Verification:**
- Check VSCode Output panel (View → Output)
- Select "Korean Language Server" from the dropdown
- Look for initialization messages

### Step 4: Test Diagnostics (Requirement 2.1, 2.2, 2.4)

**Test Case 1: Valid Code**
```korean
함수 인사하기(이름) {
  변수 메시지 = "안녕하세요, " + 이름
  반환 메시지
}
```
Expected: No errors or warnings

**Test Case 2: Syntax Error**
```korean
함수 인사하기(이름) {
  변수 메시지 = "안녕하세요, " + 이름
  반환 메시지
  // Missing closing brace
```
Expected: Red squiggly line indicating syntax error

**Test Case 3: Undefined Variable**
```korean
변수 결과 = 미정의변수
```
Expected: Warning or error for undefined variable

### Step 5: Test Auto-Completion (Requirement 3.1, 3.2, 3.3)

1. Type `변수 ` in the editor
2. Press Ctrl+Space to trigger completion
3. Verify completion suggestions appear

**Expected Suggestions:**
- Keywords (함수, 변수, 반환, etc.)
- Defined symbols in scope
- Built-in functions

### Step 6: Test Hover Information (Requirement 4.1, 4.2, 4.3)

1. Hover mouse over a defined function name (e.g., `인사하기`)
2. Verify hover tooltip appears

**Expected Information:**
- Symbol type (Function)
- Parameter information
- Definition location

### Step 7: Test Go to Definition (Requirement 5.1, 5.2, 5.3)

1. Right-click on a function call (e.g., `인사하기("세계")`)
2. Select "Go to Definition" or press F12
3. Verify cursor jumps to function definition

**Expected Behavior:**
- Cursor moves to the line where `함수 인사하기` is defined
- Definition is highlighted

### Step 8: Test Document Changes (Requirement 2.1)

1. Make changes to the document
2. Verify diagnostics update in real-time
3. Save the document
4. Verify no errors occur during save

### Step 9: Test Server Restart (Requirement 7.2)

1. Open VSCode Command Palette (Ctrl+Shift+P / Cmd+Shift+P)
2. Type "Korean Language Server: Restart"
3. Execute the command
4. Verify server restarts successfully
5. Verify language features still work after restart

### Step 10: Verify Logging (Requirement 8.1, 8.2, 8.3, 8.4)

**Check Server Logs:**
```bash
cat ~/.korean-ls.log
```

**Expected Log Content:**
- Server initialization messages
- LSP message exchanges
- Document open/change notifications
- Request/response pairs

**Check VSCode Output:**
1. Open Output panel (View → Output)
2. Select "Korean Language Server" from dropdown
3. Verify client-side logging

### Step 11: Test Error Handling (Requirement 7.1, 7.3, 7.4)

**Test Case 1: Invalid Server Path**
1. Open VSCode Settings
2. Change "Korean Language Server: Server Path" to invalid path
3. Reload window
4. Verify error message appears

**Test Case 2: Server Crash Recovery**
1. Kill the server process manually (if possible)
2. Verify VSCode detects crash
3. Verify restart prompt appears

## Integration Test Checklist

- [ ] OCaml server builds without errors
- [ ] VSCode extension compiles without errors
- [ ] Extension loads in Development Host
- [ ] Language server starts successfully
- [ ] Diagnostics appear for syntax errors
- [ ] Auto-completion provides suggestions
- [ ] Hover shows symbol information
- [ ] Go to Definition navigates correctly
- [ ] Document changes trigger updates
- [ ] Server restart works correctly
- [ ] Logs are generated correctly
- [ ] Error handling works as expected

## Sample Test Files

### test_sample.kr (Basic Features)
```korean
함수 인사하기(이름) {
  변수 메시지 = "안녕하세요, " + 이름
  반환 메시지
}

변수 결과 = 인사하기("세계")
출력(결과)
```

### test_errors.kr (Error Detection)
```korean
// Syntax error: missing closing brace
함수 테스트() {
  변수 x = 10

// Undefined variable
변수 y = 미정의변수

// Duplicate definition
함수 중복() { }
함수 중복() { }
```

### test_completion.kr (Auto-completion)
```korean
함수 계산(a, b) {
  변수 합계 = a + b
  변수 차이 = a - b
  반환 합계
}

// Type here to test completion
변수 
```

## Troubleshooting

### Server Doesn't Start
- Check server path in settings
- Verify executable has execute permissions
- Check Output panel for error messages
- Review server logs at ~/.korean-ls.log

### No Diagnostics Appearing
- Verify file extension is .kr
- Check if language server is connected
- Try restarting the server
- Check for errors in Output panel

### Completion Not Working
- Verify cursor position
- Try manual trigger (Ctrl+Space)
- Check if document is parsed correctly
- Review server logs for errors

### Hover Not Showing
- Verify symbol is defined
- Check if analysis completed
- Try hovering over different symbols
- Review server logs

## Performance Notes

- Initial parsing may take a moment for large files
- Diagnostics should update within 1-2 seconds of changes
- Completion should respond within 500ms
- Hover should appear immediately

## Success Criteria

All integration tests pass when:
1. Server starts without errors
2. All language features work as expected
3. Error handling behaves correctly
4. Logs show proper communication
5. No crashes or hangs occur during normal usage

## Next Steps

After successful integration testing:
1. Package extension for distribution
2. Write user documentation
3. Create demo videos
4. Prepare for release
