# StockTicker (Mirror)

A mirror of [premnirmal/StockTicker](https://github.com/premnirmal/StockTicker), an open-source Android app for tracking stock prices via Yahoo Finance, compiled locally with insights for contributors.

## Overview
- **Original Author**: Prem Nirmal
- **Purpose**: Display stock prices in a widget, with portfolio management and detailed views.
- **Data Source**: Yahoo Finance API (post-`d7f62fe5`, 2020).
- **Firebase**: Crashlytics (since `d96b9825`, 2018) and Analytics (since `2c0e7f50`, 2019) for crash reporting and usage tracking.

## Compilation Journey (March 2025)
Recompiling this open-source project hit a Firebase snag—here’s how we solved it:

### Key Findings
- **Firebase Integration**:
  - Added in `d96b9825` (Aug 2018) for Crashlytics, replacing Fabric.
  - Enhanced in `0fecc3f2` (2022) with updated Google Services and Crashlytics.
  - Used in:
    - `LoggingTree.kt`: Crashlytics logs exceptions.
    - `AnalyticsImpl.kt`: Tracks app opens and events (e.g., `APP_OPEN`).
  - Dependencies: `firebase-crashlytics:19.3.0`, `firebase-analytics:22.1.2` (prod flavor).
- **Build Issue**: 
  - Failed at `:app:compileProdDebugJavaWithJavac` due to missing `jlink` in JDK 17.
  - Fixed by installing `openjdk-17-jdk` (`sudo apt install openjdk-17-jdk`).

### How to Compile
1. **Clone**:
   ```bash
   git clone https://github.com/premnirmal/StockTicker.git
   cd StockTicker

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
- Dependency Fix: Excluded xpp3 properly for simplexml converter.

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
- Works: Cloning, README push, building base APK.
- Doesn’t Work Yet: Polling and rotation not implemented.

## Next Steps
- Add polling settings (`prefs.xml`, `arrays.xml`, `RefreshWorker.kt`).
- Implement free source rotation in `StocksApi.kt`.
- **March 09, 2025**: Fixed kotlin-parcelize error by reordering plugins (com.android.application first).
- **March 09, 2025**: Fixed Kapt error by adding IStocksProvider.kt to model package.
