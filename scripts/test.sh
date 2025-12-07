#!/bin/bash
set -e

echo "=== Testing Wiry.Tui ==="
cd "$(dirname "$0")/.."

dotnet test --no-build --configuration Release --verbosity normal

echo "[OK] Tests passed"
