#!/bin/bash

# Script to check Korean Language Server logs

echo "=== Korean Language Server Log Checker ==="
echo ""

LOG_FILE="$HOME/.korean-ls.log"

if [ -f "$LOG_FILE" ]; then
    echo "✓ Log file found at: $LOG_FILE"
    echo ""
    echo "File size: $(du -h "$LOG_FILE" | cut -f1)"
    echo "Last modified: $(stat -f "%Sm" "$LOG_FILE")"
    echo ""
    echo "=== Last 50 lines of log ==="
    tail -50 "$LOG_FILE"
else
    echo "⚠ Log file not found at: $LOG_FILE"
    echo ""
    echo "The log file will be created when the language server starts."
    echo "To start the server:"
    echo "1. Open VSCode in this workspace"
    echo "2. Press F5 to launch Extension Development Host"
    echo "3. Open a .kr file"
    echo "4. Run this script again to see logs"
fi

echo ""
echo "=== Log Monitoring ==="
echo "To monitor logs in real-time, run:"
echo "  tail -f $LOG_FILE"
