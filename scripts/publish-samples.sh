#!/bin/bash
set -e

echo "=== Publishing Wiry.Tui Samples (AOT) ==="
cd "$(dirname "$0")/.."

RID="${1:-}"

if [ -z "$RID" ]; then
    # Auto-detect RID
    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64) RID="osx-arm64" ;;
        Darwin-x86_64) RID="osx-x64" ;;
        Linux-x86_64) RID="linux-x64" ;;
        Linux-aarch64) RID="linux-arm64" ;;
        MINGW*|MSYS*) RID="win-x64" ;;
        *) echo "[ERROR] Unknown platform"; exit 1 ;;
    esac
    echo "[OK] Auto-detected RID: $RID"
fi

OUTPUT_DIR="./artifacts/samples/$RID"
mkdir -p "$OUTPUT_DIR"

echo "[OK] Publishing samples for: $RID"
echo "[OK] Output: $OUTPUT_DIR"

# Find and publish all sample projects
for sample in samples/*/; do
    if [ -d "$sample" ]; then
        sample_name=$(basename "$sample")
        echo ""
        echo "--- Publishing $sample_name ---"

        dotnet publish "$sample" \
            --configuration Release \
            --runtime "$RID" \
            --output "$OUTPUT_DIR"
    fi
done

echo ""
echo "[OK] All samples published to $OUTPUT_DIR"
ls -la "$OUTPUT_DIR"
