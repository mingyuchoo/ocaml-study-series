# Korean Language Server - Manual Test Checklist

## Overview
This checklist guides you through manual integration testing of the Korean Language Server in VSCode.

**Prerequisites:**
- ✅ Run `./test_integration.sh` first to verify build status
- ✅ OCaml server built successfully
- ✅ VSCode extension compiled successfully

---

## Test Execution Steps

### 1. Launch Extension Development Host

**Steps:**
1. Open this workspace in VSCode
2. Press `F5` or go to Run → Start Debugging
3. Select "Run Extension" if prompted
4. A new VSCode window will open (Extension Development Host)

**Expected Result:**
- [ ] New VSCode window opens without errors
- [ ] No error notifications appear

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Notes:**
```
_____________________________________________
_____________________________________________
```

---

### 2. Open Sample Korean File (Requirement 1.1)

**Steps:**
1. In the Extension Development Host window, open `test_sample.kr`
2. Observe the status bar

**Expected Result:**
- [ ] File opens successfully
- [ ] Syntax highlighting appears (if configured)
- [ ] No error messages about server startup

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Notes:**
```
_____________________________________________
_____________________________________________
```

---

### 3. Verify Server Connection (Requirement 1.2, 1.3)

**Steps:**
1. Open Output panel: View → Output
2. Select "Korean Language Server" from dropdown
3. Look for initialization messages

**Expected Result:**
- [ ] Output panel shows server connection messages
- [ ] "Server initialized" or similar message appears
- [ ] No error messages in output

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Notes:**
```
_____________________________________________
_____________________________________________
```

---

### 4. Test Syntax Error Detection (Requirement 2.1, 2.2, 2.4)

**Steps:**
1. Open `test_errors.kr`
2. Observe the Problems panel (View → Problems)
3. Look for red squiggly lines in the editor

**Expected Result:**
- [ ] Syntax errors are highlighted with red squiggles
- [ ] Problems panel shows error messages
- [ ] Error messages are in Korean or descriptive
- [ ] Line numbers match actual error locations

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Errors Found:**
```
Line | Error Message
-----|------------------------------------------
     |
     |
     |
```

---

### 5. Test Real-time Diagnostics (Requirement 2.1)

**Steps:**
1. Open `test_sample.kr`
2. Delete a closing brace `}`
3. Wait 1-2 seconds
4. Observe if error appears
5. Add the brace back
6. Observe if error disappears

**Expected Result:**
- [ ] Error appears within 2 seconds of making mistake
- [ ] Error disappears when fixed
- [ ] No lag or performance issues

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Notes:**
```
_____________________________________________
_____________________________________________
```

---

### 6. Test Auto-Completion (Requirement 3.1, 3.2, 3.3)

**Steps:**
1. Open `test_completion.kr`
2. Go to the line with `변수 결과 = `
3. Press `Ctrl+Space` (or `Cmd+Space` on Mac)
4. Observe completion suggestions

**Expected Result:**
- [ ] Completion menu appears
- [ ] Shows defined functions (계산, 곱하기)
- [ ] Shows keywords (함수, 변수, 반환)
- [ ] Each item has appropriate icon/kind
- [ ] Selecting an item inserts it correctly

**Completions Shown:**
```
Item          | Kind      | Detail
--------------|-----------|------------------
              |           |
              |           |
              |           |
```

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 7. Test Hover Information (Requirement 4.1, 4.2, 4.3)

**Steps:**
1. Open `test_comprehensive.kr`
2. Hover mouse over function name `더하기` (line 8)
3. Observe hover tooltip
4. Hover over variable `숫자1`
5. Observe hover tooltip

**Expected Result:**
- [ ] Hover tooltip appears for functions
- [ ] Shows function signature or type
- [ ] Shows parameter information
- [ ] Hover tooltip appears for variables
- [ ] Information is formatted clearly

**Hover Content:**
```
Symbol: 더하기
Info: _________________________________
      _________________________________

Symbol: 숫자1
Info: _________________________________
      _________________________________
```

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 8. Test Go to Definition (Requirement 5.1, 5.2, 5.3)

**Steps:**
1. Open `test_comprehensive.kr`
2. Find the line `변수 합계 = 더하기(숫자1, 숫자2)` (around line 27)
3. Right-click on `더하기` → "Go to Definition" (or press F12)
4. Observe cursor movement

**Expected Result:**
- [ ] Cursor jumps to function definition (line 8)
- [ ] Definition line is highlighted
- [ ] Can navigate back with Alt+Left

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Notes:**
```
_____________________________________________
_____________________________________________
```

---

### 9. Test Multiple Files

**Steps:**
1. Open both `test_sample.kr` and `test_comprehensive.kr`
2. Switch between tabs
3. Make edits in both files
4. Observe diagnostics update in each

**Expected Result:**
- [ ] Both files are tracked independently
- [ ] Diagnostics update correctly for each file
- [ ] No cross-file interference
- [ ] Switching tabs is smooth

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 10. Test Server Restart (Requirement 7.2)

**Steps:**
1. Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P)
2. Type "Korean Language Server: Restart"
3. Execute the command
4. Wait for restart
5. Test a language feature (e.g., completion)

**Expected Result:**
- [ ] Restart command is available
- [ ] Server restarts without errors
- [ ] Language features work after restart
- [ ] No data loss or corruption

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 11. Verify Logging (Requirement 8.1, 8.2, 8.3, 8.4)

**Steps:**
1. Check log file location: `~/.korean-ls.log`
2. Open the log file in a text editor
3. Look for LSP messages

**Expected Result:**
- [ ] Log file exists at `~/.korean-ls.log`
- [ ] Contains initialization messages
- [ ] Contains request/response pairs
- [ ] Timestamps are present
- [ ] Log level is appropriate (not too verbose)

**Log Sample:**
```
_____________________________________________
_____________________________________________
_____________________________________________
```

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 12. Test Error Handling (Requirement 7.1, 7.3)

**Steps:**
1. Create a file with invalid JSON-like content
2. Observe how server handles it
3. Check Output panel for error messages

**Expected Result:**
- [ ] Server doesn't crash
- [ ] Appropriate error message shown
- [ ] Server continues to work for other files

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

---

### 13. Performance Test

**Steps:**
1. Open `test_comprehensive.kr`
2. Make rapid edits (type quickly)
3. Observe responsiveness
4. Check CPU usage

**Expected Result:**
- [ ] Editor remains responsive
- [ ] Diagnostics update smoothly
- [ ] No noticeable lag
- [ ] CPU usage is reasonable (<50% for server)

**Status:** ⬜ Not Started | ⬜ Pass | ⬜ Fail

**Performance Notes:**
```
Diagnostic update time: _______ ms
Completion response time: _______ ms
CPU usage: _______ %
```

---

## Test Summary

### Results Overview

| Test | Status | Notes |
|------|--------|-------|
| 1. Launch Extension | ⬜ | |
| 2. Open File | ⬜ | |
| 3. Server Connection | ⬜ | |
| 4. Syntax Errors | ⬜ | |
| 5. Real-time Diagnostics | ⬜ | |
| 6. Auto-Completion | ⬜ | |
| 7. Hover Info | ⬜ | |
| 8. Go to Definition | ⬜ | |
| 9. Multiple Files | ⬜ | |
| 10. Server Restart | ⬜ | |
| 11. Logging | ⬜ | |
| 12. Error Handling | ⬜ | |
| 13. Performance | ⬜ | |

**Total Passed:** _____ / 13

**Overall Status:** ⬜ All Pass | ⬜ Some Failures | ⬜ Major Issues

---

## Issues Found

### Issue 1
**Severity:** ⬜ Critical | ⬜ Major | ⬜ Minor

**Description:**
```
_____________________________________________
_____________________________________________
```

**Steps to Reproduce:**
```
1. 
2. 
3. 
```

**Expected vs Actual:**
```
Expected: ___________________________________
Actual: _____________________________________
```

---

### Issue 2
**Severity:** ⬜ Critical | ⬜ Major | ⬜ Minor

**Description:**
```
_____________________________________________
_____________________________________________
```

---

## Sign-off

**Tester Name:** _______________________

**Date:** _______________________

**Overall Assessment:**
```
_____________________________________________
_____________________________________________
_____________________________________________
```

**Ready for Release:** ⬜ Yes | ⬜ No | ⬜ With Fixes

---

## Quick Reference

### Useful Commands
- Launch Extension: `F5`
- Open Command Palette: `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
- Trigger Completion: `Ctrl+Space` or `Cmd+Space`
- Go to Definition: `F12`
- Go Back: `Alt+Left` or `Ctrl+-`
- Open Output Panel: `Ctrl+Shift+U` or `Cmd+Shift+U`
- Open Problems Panel: `Ctrl+Shift+M` or `Cmd+Shift+M`

### File Locations
- Server Executable: `_build/default/bin/main.exe`
- Extension Output: `vscode-extension/out/`
- Log File: `~/.korean-ls.log`
- Test Files: `test_*.kr`

### Expected Behavior Summary
- Server starts automatically when .kr file is opened
- Diagnostics appear within 1-2 seconds of changes
- Completion suggestions include keywords and defined symbols
- Hover shows type and definition information
- Go to Definition navigates to symbol definition
- Logs capture all LSP communication
