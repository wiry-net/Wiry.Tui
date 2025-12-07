#!/bin/bash
set -e

echo "=== Checking code formatting ==="
cd "$(dirname "$0")/.."

dotnet format --verify-no-changes --verbosity normal

echo "[OK] Formatting check passed"
