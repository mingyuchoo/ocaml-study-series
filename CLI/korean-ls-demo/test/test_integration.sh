#!/bin/bash

# Korean Language Server - Automated Integration Test Script
# This script verifies the integration between the OCaml server and VSCode extension

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Log file location
LOG_FILE="$HOME/.korean-ls.log"
TEST_LOG="./integration_test.log"

# Function to print test results
print_test() {
    local status=$1
    local message=$2
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}✗${NC} $message"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    elif [ "$status" = "SKIP" ]; then
        echo -e "${YELLOW}⊘${NC} $message"
    else
        echo -e "${BLUE}ℹ${NC} $message"
    fi
}

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

# Clear previous test log
> "$TEST_LOG"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║   Korean Language Server - Integration Test Suite    ║"
echo "╔═══════════════════════════════════════════════════════╗"
echo -e "${NC}"

# Test 1: Build Verification
print_section "1. Build Verification"

# Test 1.1: OCaml Server Build
if [ -f "_build/default/bin/main.exe" ]; then
    print_test "PASS" "OCaml server executable exists"
else
    print_test "FAIL" "OCaml server executable not found"
    echo "  Expected: _build/default/bin/main.exe"
fi

# Test 1.2: VSCode Extension Build
if [ -f "vscode-extension/out/extension.js" ]; then
    print_test "PASS" "VSCode extension compiled (extension.js)"
else
    print_test "FAIL" "VSCode extension not compiled"
fi

if [ -f "vscode-extension/out/client.js" ]; then
    print_test "PASS" "VSCode extension compiled (client.js)"
else
    print_test "FAIL" "Client module not compiled"
fi

if [ -f "vscode-extension/out/configuration.js" ]; then
    print_test "PASS" "VSCode extension compiled (configuration.js)"
else
    print_test "FAIL" "Configuration module not compiled"
fi

# Test 2: Sample Files Verification
print_section "2. Sample Test Files"

if [ -f "test_sample.kr" ]; then
    print_test "PASS" "test_sample.kr exists"
else
    print_test "FAIL" "test_sample.kr not found"
fi

if [ -f "test_completion.kr" ]; then
    print_test "PASS" "test_completion.kr exists"
else
    print_test "FAIL" "test_completion.kr not found"
fi

if [ -f "test_errors.kr" ]; then
    print_test "PASS" "test_errors.kr exists"
else
    print_test "FAIL" "test_errors.kr not found"
fi

# Test 3: Server Executable Verification
print_section "3. Server Executable Tests"

if [ -x "_build/default/bin/main.exe" ]; then
    print_test "PASS" "Server executable has execute permissions"
else
    print_test "FAIL" "Server executable is not executable"
    echo "  Run: chmod +x _build/default/bin/main.exe"
fi

# Test 4: Extension Package Configuration
print_section "4. Extension Configuration"

if [ -f "vscode-extension/package.json" ]; then
    print_test "PASS" "package.json exists"
    
    # Check for required fields
    if grep -q '"activationEvents"' vscode-extension/package.json; then
        print_test "PASS" "activationEvents defined in package.json"
    else
        print_test "FAIL" "activationEvents not found in package.json"
    fi
    
    if grep -q '"contributes"' vscode-extension/package.json; then
        print_test "PASS" "contributes section defined in package.json"
    else
        print_test "FAIL" "contributes section not found in package.json"
    fi
else
    print_test "FAIL" "package.json not found"
fi

# Test 5: Language Configuration
print_section "5. Language Configuration"

if [ -f "vscode-extension/language-configuration.json" ]; then
    print_test "PASS" "language-configuration.json exists"
else
    print_test "FAIL" "language-configuration.json not found"
fi

# Test 6: Server Communication Test (Basic)
print_section "6. Server Communication Test"

print_test "INFO" "Server communication requires VSCode runtime"
print_test "SKIP" "Automated server test (requires manual VSCode testing)"
print_test "INFO" "Use 'Manual Test Checklist' section below for full testing"

# Test 7: Log File Creation
print_section "7. Logging Verification"

print_test "INFO" "Log file location: $LOG_FILE"
if [ -f "$LOG_FILE" ]; then
    print_test "PASS" "Log file exists at $LOG_FILE"
    
    # Check log file size
    LOG_SIZE=$(wc -c < "$LOG_FILE")
    if [ "$LOG_SIZE" -gt 0 ]; then
        print_test "PASS" "Log file contains data ($LOG_SIZE bytes)"
        echo "  Last 3 log entries:"
        tail -n 3 "$LOG_FILE" | sed 's/^/    /'
    else
        print_test "INFO" "Log file is empty (will be populated when server runs)"
    fi
else
    print_test "INFO" "Log file will be created when server runs in VSCode"
fi

# Test 8: Extension Dependencies
print_section "8. Extension Dependencies"

if [ -d "vscode-extension/node_modules" ]; then
    print_test "PASS" "node_modules directory exists"
    
    if [ -d "vscode-extension/node_modules/vscode-languageclient" ]; then
        print_test "PASS" "vscode-languageclient installed"
    else
        print_test "FAIL" "vscode-languageclient not installed"
    fi
else
    print_test "FAIL" "node_modules not found - run npm install"
fi

# Test 9: Sample File Content Validation
print_section "9. Sample File Content Validation"

if [ -f "test_sample.kr" ]; then
    if grep -q "함수" test_sample.kr; then
        print_test "PASS" "test_sample.kr contains Korean keywords"
    else
        print_test "FAIL" "test_sample.kr missing Korean keywords"
    fi
    
    if grep -q "변수" test_sample.kr; then
        print_test "PASS" "test_sample.kr contains variable declarations"
    else
        print_test "FAIL" "test_sample.kr missing variable declarations"
    fi
fi

if [ -f "test_errors.kr" ]; then
    # This file should have intentional errors
    print_test "PASS" "test_errors.kr exists for error testing"
fi

# Test 10: Documentation
print_section "10. Documentation Verification"

if [ -f "INTEGRATION_TEST.md" ]; then
    print_test "PASS" "Integration test documentation exists"
else
    print_test "FAIL" "INTEGRATION_TEST.md not found"
fi

if [ -f "README.md" ]; then
    print_test "PASS" "README.md exists"
else
    print_test "SKIP" "README.md not found"
fi

# Test Summary
print_section "Test Summary"

echo ""
echo -e "Total Tests:  ${BLUE}$TESTS_TOTAL${NC}"
echo -e "Passed:       ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:       ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           ALL INTEGRATION TESTS PASSED! ✓             ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  1. Open VSCode and press F5 to launch Extension Development Host"
    echo "  2. Open test_sample.kr in the new window"
    echo "  3. Verify language features work (completion, hover, diagnostics)"
    echo "  4. Check logs at: $LOG_FILE"
    echo ""
    exit 0
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║        SOME INTEGRATION TESTS FAILED! ✗               ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Please fix the failed tests before proceeding.${NC}"
    echo ""
    exit 1
fi
