# StockPulse
A fork of [StockTicker](https://github.com/premnirmal/StockTicker) by [q-killer](https://github.com/q-killer), enhancing stock polling with free sources.

## Project Goals
- Adjustable Polling: Intervals of 1, 2, 3, or 5 minutes (original: 15 minutes).
- Free Source Rotation: Use public stock sites (Google Finance, Yahoo, etc.) without API keys.
- Lean Design: No extra libraries beyond the original footprint.
- Optional API Keys: Add a settings option for premium sources (future enhancement).

## Development Approach
- Environment: Linux Mint Debian Edition (LMDE), command-line only (no Android Studio).
- Tools: Git, Gradle, Android SDK (CLI tools).
- Method: Minimal changes to the fork, tested incrementally.

## Discoveries
- Fork Baseline: Builds from `q-killer/StockPulse` with `./gradlew build` (environment check).
- Firebase Optional: Crashlytics/Analytics removed from `app/build.gradle`.
- Git Versioning: Replaced `git describe` with date-based version (`yyyyMMdd`).
- Syntax Issues: Gradle edits need careful block alignment.

## Project Layout
- `app/build.gradle`: Core config (dependencies, build types).
- `app/src/main/kotlin/com/github/premnirmal/ticker/network/StocksApi.kt`: Stock fetching logic.
- `app/src/main/kotlin/com/github/premnirmal/ticker/model/StocksProvider.kt`: Stock data management.
- `app/src/main/res/values/strings.xml`: App strings (e.g., `app_name`).
- `app/src/main/res/xml/prefs.xml`: Settings (to be added).

## Contributing
- Permission: Fork from `github.com/q-killer/StockPulse`, submit PRs to `master`.
- Steps:
  1. Clone: `git clone https://github.com/q-killer/StockPulse.git`
  2. Build: `cd StockPulse && ./gradlew assembleDebug`
  3. Test: Use QEMU emulator (TBD).
  4. PR: Push to your fork, open a PR to `q-killer/StockPulse`.

## Setup Instructions
```bash
# Clone the fork
git clone https://github.com/q-killer/StockPulse.git ~/StockPulse
cd ~/StockPulse

# Build
./gradlew assembleDebug

# Check APK
ls ~/StockPulse/app/build/outputs/apk/debug/
```

## Status
- Works: Cloning, basic build with date-based versioning.
- Doesn’t Work Yet: Polling and rotation not implemented.

## Next Steps
- Add polling settings (`prefs.xml`, `arrays.xml`, `RefreshWorker.kt`.
- Implement free source rotation in `StocksApi.kt`.
