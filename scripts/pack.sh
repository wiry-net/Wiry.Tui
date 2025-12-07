#!/bin/bash
set -e

echo "=== Packing Wiry.Tui ==="
cd "$(dirname "$0")/.."

OUTPUT_DIR="./artifacts/packages"
mkdir -p "$OUTPUT_DIR"

dotnet pack src/Wiry.Tui/Wiry.Tui.csproj \
    --no-build \
    --configuration Release \
    --output "$OUTPUT_DIR"

echo "[OK] Package created in $OUTPUT_DIR"
ls -la "$OUTPUT_DIR"
