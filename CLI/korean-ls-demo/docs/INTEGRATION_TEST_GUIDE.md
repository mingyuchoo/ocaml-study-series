# Korean Language Server - Integration Test Guide

## Quick Start

### Automated Tests

Run the automated integration test script:

```bash
./test_integration.sh
```

This script verifies:
- ✅ Build artifacts exist
- ✅ Sample test files are present
- ✅ Extension configuration is correct
- ✅ Dependencies are installed
- ✅ File permissions are correct

### Manual Tests

After automated tests pass, perform manual testing in VSCode:

1. **Launch Extension Development Host:**
   ```
   Press F5 in VSCode
   ```

2. **Follow the Manual Test Checklist:**
   ```
   Open MANUAL_TEST_CHECKLIST.md
   ```

3. **Use Test Files:**
   - `test_sample.kr` - Basic functionality
   - `test_comprehensive.kr` - All features
   - `test_completion.kr` - Auto-completion
   - `test_errors.kr` - Error detection

---

## Test Files Overview

### test_sample.kr
Basic Korean language file with simple functions and variables.

**Tests:**
- Function definitions
- Variable declarations
- Function calls
- Basic syntax

### test_comprehensive.kr
Comprehensive test file covering all language features.

**Tests:**
- Multiple function definitions
- Variable scoping
- Nested functions
- Auto-completion areas
- Hover test areas
- Go to definition test areas
- Complex expressions

### test_completion.kr
Focused on testing auto-completion functionality.

**Tests:**
- Completion after variable declaration
- Completion in function calls
- Keyword completion

### test_errors.kr
Contains intentional errors for testing diagnostics.

**Tests:**
- Syntax errors (missing braces)
- Undefined variables
- Duplicate definitions

---

## Integration Test Workflow

```
┌─────────────────────────────────────────┐
│  1. Run Automated Tests                 │
│     ./test_integration.sh               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  2. Launch VSCode Extension (F5)        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  3. Open Test Files                     │
│     - test_sample.kr                    │
│     - test_comprehensive.kr             │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  4. Verify Language Features            │
│     ✓ Diagnostics                       │
│     ✓ Auto-completion                   │
│     ✓ Hover information                 │
│     ✓ Go to definition                  │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  5. Check Logs                          │
│     ~/.korean-ls.log                    │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  6. Complete Manual Checklist           │
│     MANUAL_TEST_CHECKLIST.md            │
└─────────────────────────────────────────┘
```

---

## Requirements Coverage

### Requirement 1.1 - Extension Activation
**Test:** Launch Extension Development Host and open .kr file
**Verify:** Server starts automatically

### Requirement 1.2 - LSP Initialization
**Test:** Check Output panel for initialization messages
**Verify:** Server responds with capabilities

### Requirement 1.3 - Connection Status
**Test:** Observe status bar and output panel
**Verify:** Connection status is displayed

### Requirement 2.1 - Document Parsing
**Test:** Open test_sample.kr
**Verify:** File is parsed without errors

### Requirement 2.2 - Diagnostics
**Test:** Open test_errors.kr
**Verify:** Errors are highlighted

### Requirement 2.3 - Real-time Updates
**Test:** Make edits in test_sample.kr
**Verify:** Diagnostics update within 2 seconds

### Requirement 2.4 - Diagnostic Details
**Test:** Hover over error in test_errors.kr
**Verify:** Error message includes line, column, severity

### Requirement 3.1 - Completion Request
**Test:** Press Ctrl+Space in test_completion.kr
**Verify:** Completion menu appears

### Requirement 3.2 - Context Analysis
**Test:** Trigger completion in different contexts
**Verify:** Suggestions are context-appropriate

### Requirement 3.3 - Completion Details
**Test:** Examine completion items
**Verify:** Each item has label, kind, detail

### Requirement 4.1 - Hover Request
**Test:** Hover over function name
**Verify:** Hover tooltip appears

### Requirement 4.2 - Symbol Identification
**Test:** Hover over various symbols
**Verify:** Correct information is shown

### Requirement 4.3 - Hover Format
**Test:** Check hover content
**Verify:** Information is in markdown format

### Requirement 5.1 - Definition Request
**Test:** Press F12 on function call
**Verify:** Navigation occurs

### Requirement 5.2 - Symbol Search
**Test:** Go to definition on various symbols
**Verify:** Correct definition is found

### Requirement 5.3 - Location Information
**Test:** Verify navigation accuracy
**Verify:** Cursor moves to exact definition location

### Requirement 6.1 - Server Build
**Test:** Run `dune build`
**Verify:** Build succeeds

### Requirement 6.2 - Extension Build
**Test:** Run `npm run compile`
**Verify:** TypeScript compiles

### Requirement 6.3 - Configuration
**Test:** Check VSCode settings
**Verify:** Server path is configurable

### Requirement 6.4 - Configuration Changes
**Test:** Change settings and reload
**Verify:** Server restarts with new settings

### Requirement 7.1 - Exception Handling
**Test:** Trigger server error
**Verify:** Error is logged and LSP error returned

### Requirement 7.2 - Server Crash Recovery
**Test:** Kill server process
**Verify:** Extension detects crash and offers restart

### Requirement 7.3 - Protocol Errors
**Test:** Send invalid message (if possible)
**Verify:** Server handles gracefully

### Requirement 7.4 - Timeout Handling
**Test:** Observe long-running operations
**Verify:** Timeouts are handled

### Requirement 8.1 - Message Logging
**Test:** Check ~/.korean-ls.log
**Verify:** LSP messages are logged

### Requirement 8.2 - Log Levels
**Test:** Review log file
**Verify:** Different log levels are used

### Requirement 8.3 - Debug Mode
**Test:** Enable debug mode in settings
**Verify:** Verbose logs appear in Output panel

### Requirement 8.4 - Log Configuration
**Test:** Check log file location
**Verify:** Log file is at expected location

---

## Verification Checklist

### Pre-Test Verification
- [ ] OCaml server built: `_build/default/bin/main.exe` exists
- [ ] Extension compiled: `vscode-extension/out/` contains .js files
- [ ] Dependencies installed: `vscode-extension/node_modules/` exists
- [ ] Test files present: `test_*.kr` files exist

### Automated Test Results
- [ ] All automated tests pass
- [ ] No build errors
- [ ] No missing dependencies
- [ ] Configuration files valid

### Manual Test Results
- [ ] Extension loads in VSCode
- [ ] Server starts successfully
- [ ] Diagnostics work correctly
- [ ] Auto-completion works
- [ ] Hover information works
- [ ] Go to definition works
- [ ] Logging is functional
- [ ] Error handling works

### Log Verification
- [ ] Log file created at `~/.korean-ls.log`
- [ ] Contains initialization messages
- [ ] Contains LSP request/response pairs
- [ ] No unexpected errors
- [ ] Timestamps are correct

---

## Troubleshooting

### Server Doesn't Start

**Symptoms:**
- No output in "Korean Language Server" output channel
- Error notification on file open

**Solutions:**
1. Check server path in settings
2. Verify executable permissions: `chmod +x _build/default/bin/main.exe`
3. Rebuild server: `dune build`
4. Check for OCaml runtime errors

### No Diagnostics Appearing

**Symptoms:**
- Errors in code but no red squiggles
- Problems panel is empty

**Solutions:**
1. Verify file extension is `.kr`
2. Check if server is connected (Output panel)
3. Try restarting server (Command Palette → "Korean Language Server: Restart")
4. Check server logs for parsing errors

### Completion Not Working

**Symptoms:**
- Ctrl+Space shows no suggestions
- Only default VSCode suggestions appear

**Solutions:**
1. Verify cursor position is valid
2. Check if document is parsed (no syntax errors)
3. Try manual trigger: Ctrl+Space
4. Review server logs for errors

### Hover Not Showing

**Symptoms:**
- No tooltip appears on hover
- Tooltip shows generic information

**Solutions:**
1. Verify symbol is defined in current file
2. Check if analysis completed (no errors in Output)
3. Try hovering over different symbols
4. Review server logs

### Go to Definition Not Working

**Symptoms:**
- F12 does nothing
- "No definition found" message

**Solutions:**
1. Verify symbol is defined in current file
2. Check if symbol table is built (no errors)
3. Try on different symbols
4. Review server logs for analysis errors

---

## Performance Benchmarks

### Expected Performance

| Operation | Expected Time | Acceptable Range |
|-----------|---------------|------------------|
| Server Startup | < 1 second | 0.5 - 2 seconds |
| File Open | < 500ms | 100ms - 1 second |
| Diagnostics Update | < 1 second | 500ms - 2 seconds |
| Completion Response | < 300ms | 100ms - 500ms |
| Hover Response | < 100ms | 50ms - 200ms |
| Go to Definition | < 100ms | 50ms - 200ms |

### Performance Testing

1. **Measure Diagnostic Update Time:**
   - Make a change in test_comprehensive.kr
   - Note time until diagnostics appear
   - Should be < 2 seconds

2. **Measure Completion Response:**
   - Trigger completion in test_completion.kr
   - Note time until menu appears
   - Should be < 500ms

3. **Check CPU Usage:**
   - Monitor server process during editing
   - Should be < 50% CPU during normal use
   - Brief spikes during parsing are acceptable

---

## Success Criteria

Integration testing is successful when:

1. ✅ All automated tests pass
2. ✅ Extension loads without errors
3. ✅ Server starts and initializes
4. ✅ All language features work as expected:
   - Diagnostics
   - Auto-completion
   - Hover information
   - Go to definition
5. ✅ Logging captures all communication
6. ✅ Error handling works correctly
7. ✅ Performance is acceptable
8. ✅ No crashes or hangs during normal use

---

## Next Steps After Testing

### If All Tests Pass:
1. Package extension: `vsce package`
2. Create release notes
3. Prepare documentation
4. Consider beta release

### If Tests Fail:
1. Document failures in MANUAL_TEST_CHECKLIST.md
2. Review server logs for errors
3. Fix identified issues
4. Re-run tests
5. Iterate until all tests pass

---

## Additional Resources

- **Detailed Manual Checklist:** `MANUAL_TEST_CHECKLIST.md`
- **Integration Test Documentation:** `INTEGRATION_TEST.md`
- **Requirements:** `.kiro/specs/korean-language-server/requirements.md`
- **Design:** `.kiro/specs/korean-language-server/design.md`
- **Server Logs:** `~/.korean-ls.log`
- **VSCode Output:** View → Output → "Korean Language Server"

---

## Contact & Support

For issues or questions:
1. Check server logs: `~/.korean-ls.log`
2. Check VSCode output panel
3. Review INTEGRATION_TEST.md for detailed guidance
4. Consult design document for architecture details
