#!/bin/bash
set -e

echo "=== Running JetBrains InspectCode ==="
cd "$(dirname "$0")/.."

SOLUTION="Wiry.Tui.sln"
OUTPUT_FILE="${1:-inspectcode-report.sarif}"
MIN_SEVERITY="${2:-WARNING}"

# Check if jb inspectcode is installed
if ! command -v jb &> /dev/null; then
    echo "[ERROR] JetBrains CLI tools not found"
    echo "Install: dotnet tool install -g JetBrains.ReSharper.GlobalTools"
    exit 1
fi

echo "[OK] Running static analysis on $SOLUTION"
echo "[OK] Minimum severity: $MIN_SEVERITY"
echo "[OK] Output: $OUTPUT_FILE"

jb inspectcode "$SOLUTION" \
    --output="$OUTPUT_FILE" \
    --severity="$MIN_SEVERITY" \
    --verbosity=WARN

# Check if SARIF file was created
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "[ERROR] InspectCode failed to produce output file"
    exit 1
fi

# Parse results using jq if available
if command -v jq &> /dev/null; then
    echo ""
    echo "=== Analysis Results ==="

    ERRORS=$(jq -r '[.runs[0].results[] | select(.level=="error")] | length' "$OUTPUT_FILE" 2>/dev/null || echo "0")
    WARNINGS=$(jq -r '[.runs[0].results[] | select(.level=="warning")] | length' "$OUTPUT_FILE" 2>/dev/null || echo "0")
    TOTAL=$(jq -r '[.runs[0].results[]] | length' "$OUTPUT_FILE" 2>/dev/null || echo "0")

    echo "Total issues: $TOTAL"
    echo "  Errors:   $ERRORS"
    echo "  Warnings: $WARNINGS"

    if [ "$MIN_SEVERITY" = "ERROR" ] && [ "$ERRORS" -gt 0 ]; then
        echo ""
        echo "[FAIL] Found $ERRORS error(s)"
        exit 1
    fi

    if [ "$MIN_SEVERITY" = "WARNING" ] && [ $((ERRORS + WARNINGS)) -gt 0 ]; then
        echo ""
        echo "[FAIL] Found $((ERRORS + WARNINGS)) issue(s) at WARNING level or above"
        exit 1
    fi

    echo ""
    echo "[OK] Static analysis passed"
else
    echo ""
    echo "[WARN] jq not found - skipping result validation"
    echo "[WARN] Install jq for detailed statistics"
fi

echo "Analysis complete"
