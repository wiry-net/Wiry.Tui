#!/bin/bash
set -e

echo "=== Building Wiry.Tui ==="
cd "$(dirname "$0")/.."

dotnet restore
dotnet build --no-restore --configuration Release

echo "[OK] Build completed"
