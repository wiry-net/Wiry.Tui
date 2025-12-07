# CI/CD Documentation

## Overview

This repository uses GitHub Actions for continuous integration with a two-job structure:

1. **package** - Quality checks and NuGet package creation
2. **samples** - Cross-platform testing and AOT sample binaries

## Jobs

### package (Linux only)

Runs on Ubuntu and produces the main NuGet package artifact.

| Step | Description |
|------|-------------|
| format | Code style validation (`dotnet format --verify-no-changes`) |
| inspect | Static analysis (JetBrains InspectCode) |
| build | Compile solution |
| test | Run unit tests |
| pack | Create NuGet package |

**Artifact:** `Wiry.Tui.{version}.nupkg`

### samples (matrix: 1-4 OS)

Runs after `package` job. Verifies tests on multiple platforms and builds AOT sample binaries.

| Context | Platforms |
|---------|-----------|
| Feature branches | Linux only |
| main / PR to main / tags | Linux, Windows, macOS x64, macOS ARM64 |

| Step | Description |
|------|-------------|
| build | Compile solution |
| test | Run unit tests (cross-platform verification) |
| publish | AOT publish sample applications |

**Artifacts:** `samples-{rid}.zip` for each platform

## Scripts

All scripts are in the `scripts/` directory:

| Script | Purpose | Used in CI |
|--------|---------|------------|
| `build.sh` | Restore and build solution | Yes |
| `test.sh` | Run tests | Yes |
| `pack.sh` | Create NuGet package | Yes |
| `format.sh` | Check code formatting | Yes |
| `inspect.sh` | Run JetBrains InspectCode | Local only* |
| `publish-samples.sh` | AOT publish samples for RID | Yes |

*CI uses the JetBrains GitHub Action instead of the script.

## Local Development

Run the same checks locally:

```bash
# Format check
./scripts/format.sh

# Build and test
./scripts/build.sh
./scripts/test.sh

# Create package
./scripts/pack.sh

# Static analysis (requires JetBrains tools)
dotnet tool install -g JetBrains.ReSharper.GlobalTools
./scripts/inspect.sh

# Publish samples for current platform
./scripts/publish-samples.sh
```

## Artifacts

| Artifact | Source | When |
|----------|--------|------|
| `nuget-package` | package job | Always |
| `samples-linux-x64` | samples job | Always |
| `samples-win-x64` | samples job | main/PR/tags |
| `samples-osx-x64` | samples job | main/PR/tags |
| `samples-osx-arm64` | samples job | main/PR/tags |
