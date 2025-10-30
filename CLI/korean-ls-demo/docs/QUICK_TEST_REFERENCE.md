# Korean Language Server - Quick Test Reference

## 🚀 Quick Start

### Run Automated Tests
```bash
./test_integration.sh
```

### Launch Extension in VSCode
```
Press F5
```

### Open Test File
```
Open: test_comprehensive.kr
```

---

## 📋 Test Checklist (Quick)

- [ ] Automated tests pass
- [ ] Extension loads (F5)
- [ ] Open test_sample.kr
- [ ] See diagnostics for test_errors.kr
- [ ] Auto-completion works (Ctrl+Space)
- [ ] Hover shows info
- [ ] Go to definition works (F12)
- [ ] Check logs: `~/.korean-ls.log`

---

## 📁 Test Files

| File | Purpose |
|------|---------|
| `test_sample.kr` | Basic features |
| `test_comprehensive.kr` | All features |
| `test_completion.kr` | Auto-completion |
| `test_errors.kr` | Error detection |

---

## 🔍 Where to Look

### Automated Test Results
```bash
./test_integration.sh
```

### Manual Test Checklist
```
MANUAL_TEST_CHECKLIST.md
```

### Complete Guide
```
INTEGRATION_TEST_GUIDE.md
```

### Server Logs
```
~/.korean-ls.log
```

### VSCode Output
```
View → Output → "Korean Language Server"
```

---

## ⚡ Quick Commands

### VSCode
- Launch Extension: `F5`
- Command Palette: `Ctrl+Shift+P` (Win/Linux) or `Cmd+Shift+P` (Mac)
- Trigger Completion: `Ctrl+Space` or `Cmd+Space`
- Go to Definition: `F12`
- Open Output: `Ctrl+Shift+U` or `Cmd+Shift+U`

### Terminal
- Build Server: `dune build`
- Build Extension: `cd vscode-extension && npm run compile`
- Run Tests: `./test_integration.sh`
- View Logs: `cat ~/.korean-ls.log`

---

## ✅ Success Criteria

- ✅ Automated tests: 18+ passed, 0 failed
- ✅ Extension loads without errors
- ✅ Diagnostics appear for errors
- ✅ Completion provides suggestions
- ✅ Hover shows information
- ✅ Go to definition navigates
- ✅ Logs capture communication

---

## 🐛 Quick Troubleshooting

### Server Won't Start
```bash
chmod +x _build/default/bin/main.exe
dune build
```

### No Diagnostics
- Check file extension is `.kr`
- Restart server: Command Palette → "Korean Language Server: Restart"

### No Completion
- Press `Ctrl+Space` manually
- Check Output panel for errors

---

## 📚 Documentation

- `TEST_SUMMARY.md` - Overview of testing infrastructure
- `INTEGRATION_TEST_GUIDE.md` - Complete testing workflow
- `MANUAL_TEST_CHECKLIST.md` - Detailed manual tests
- `INTEGRATION_TEST.md` - Original integration guide

---

## 🎯 Test in 5 Minutes

1. **Run automated tests** (30 seconds)
   ```bash
   ./test_integration.sh
   ```

2. **Launch extension** (30 seconds)
   ```
   Press F5 in VSCode
   ```

3. **Open test file** (10 seconds)
   ```
   Open test_comprehensive.kr
   ```

4. **Test features** (3 minutes)
   - Make an error → See red squiggle
   - Type `변수 ` → Press Ctrl+Space → See completions
   - Hover over `더하기` → See info
   - Click `더하기` → Press F12 → Jump to definition

5. **Check logs** (30 seconds)
   ```bash
   cat ~/.korean-ls.log | tail -20
   ```

**Done!** ✅

---

## 📞 Need Help?

1. Check `INTEGRATION_TEST_GUIDE.md` for detailed instructions
2. Review `MANUAL_TEST_CHECKLIST.md` for step-by-step tests
3. Check server logs: `~/.korean-ls.log`
4. Check VSCode output: View → Output → "Korean Language Server"
