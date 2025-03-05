# StockTickerFork
A fork of the [Stocks Widget](https://github.com/original/stocks-widget) Android app, enhanced for faster, more reliable stock price updates using free sources.

## Features
- **Adjustable Polling**: Update intervals of 1, 2, 3, or 5 minutes (vs. original 15-minute fixed interval).
- **Source Rotation**: Pulls data from 5-7 free stock price sources (e.g., Google Finance, Yahoo Finance, MarketWatch) to avoid rate limits.
- **Lean Design**: No additional libraries; uses built-in HTTP and regex parsing.
- **Optional API Keys**: Settings option to add API keys for premium sources (e.g., Finnhub) for advanced users.

## Changes from Original
- **Polling Logic**: Modified `StockService.java` to support configurable intervals and source rotation.
- **Data Fetching**: Added `StockFetcher.java` with support for multiple free sources.
- **Settings UI**: Updated `res/xml/preferences.xml` and `res/values/arrays.xml` for polling options and API key input.
- **No Bloat**: Kept project size minimal by avoiding external dependencies.

## Setup
1. Clone the repo: `git clone https://github.com/yourusername/StockTickerFork.git`
2. Build with Gradle: `./gradlew build`
3. Install on device/emulator: `adb install app/build/outputs/apk/debug/app-debug.apk`

## Testing
Tested on a QEMU-based emulator (Android 13, API 33) with polling intervals and source rotation verified.

## Contributing
Feel free to submit PRs or issues! Focus is on keeping it lightweight and reliable.

## License
[Same as original, e.g., MIT/Apache 2.0]

ORIGINAL PROJECT CREDIT:  Thank you Prem!  I’m sorry to annoy you with my e-mail a an idiot coder!

# Stocks Widget
[![Build](https://github.com/premnirmal/StockTicker/workflows/Build/badge.svg)](https://github.com/premnirmal/StockTicker/actions) [![Unit tests](https://github.com/premnirmal/StockTicker/workflows/Run%20unit%20tests/badge.svg)](https://github.com/premnirmal/StockTicker/actions)

<a href="https://play.google.com/store/apps/details?id=com.github.premnirmal.tickerwidget" target="_blank">
<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" alt="Get it on Google Play" height="90"/></a>
<a href="https://f-droid.org/en/packages/com.github.premnirmal.tickerwidget/" target="_blank">
<img src="https://f-droid.org/badge/get-it-on.png" alt="Get it on F-Droid" height="90"/></a>

![](https://play-lh.googleusercontent.com/R9khJ5kNzXHUjO4BxNw1cNKTx62grZ7FtLRT_F2H0BhC99iuMWDxvuGTYvyydtqE3w=h400-rw)
![](https://play-lh.googleusercontent.com/uxQfuEmietfmyq4e-xNEAXfwtkWFE9iVbJYpMtc55yKqOYTv25ViSGS1dTf6qrncXIo=h400-rw)
![](https://play-lh.googleusercontent.com/fQZFK93aeUVMr0BDNIuk8Ol9i-HC4d7GCtk01VtKr2-qcdtpmR8gO3-DJMCPbTwsCA=h400-rw)

## App features

- A home screen widget that shows your stock portfolio in a resizable grid
- Stocks can be sorted by dragging and dropping the list
- Only performs automatic fetching of stocks during trading hours
- Displays price change and summary alerts

## License

GPL

### Author
[Prem Nirmal](http://premnirmal.me/)
