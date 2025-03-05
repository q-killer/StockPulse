#!/bin/bash

# Define paths
WORK_DIR="$HOME/StockTickerFork"
STOCKS_API="$WORK_DIR/app/src/main/kotlin/com/github/premnirmal/ticker/network/StocksApi.kt"

# Ensure directory exists
echo "Ensuring Kotlin directory exists..."
mkdir -p "$(dirname "$STOCKS_API")"

# Recreate StocksApi.kt
echo "Restoring StocksApi.kt..."
cat > "$STOCKS_API" << 'EOF'
package com.github.premnirmal.ticker.network

import android.os.Handler
import android.os.Looper
import com.github.premnirmal.ticker.model.IStocksProvider
import com.github.premnirmal.ticker.network.data.Quote
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import kotlin.random.Random

class StocksApi : IStocksProvider {
    private val sources = listOf(
        "https://www.google.com/finance/quote/%s", // Google Finance
        "https://www.tradingview.com/symbols/%s/", // TradingView
        "https://finance.yahoo.com/quote/%s/",     // Yahoo Finance
        "https://www.nasdaq.com/market-activity/stocks/%s", // Nasdaq
        "https://www.marketwatch.com/investing/stock/%s",   // MarketWatch
        "https://www.reuters.com/quote/%s",        // Reuters
        "https://www.bloomberg.com/quote/%s:US"    // Bloomberg
    )
    private var currentSourceIndex = 0
    private val handler = Handler(Looper.getMainLooper())
    private var fetchRunnable: Runnable? = null

    override fun fetchStocks(symbols: List<String>) {
        fetchRunnable?.let { handler.removeCallbacks(it) }
        fetchRunnable = object : Runnable {
            override fun run() {
                val quotes = mutableListOf<Quote>()
                for (symbol in symbols) {
                    fetchQuote(symbol)?.let { quotes.add(it) }
                }
                // Notify listeners (simplified—use original callback)
                handler.post {
                    // Placeholder for callback logic
                }
                // Schedule next fetch
                rotateSource()
                val interval = AppPreferences.getInstance().getPollInterval()
                handler.postDelayed(this, (interval * 1000).toLong())
            }
        }
        fetchRunnable?.run()
    }

    private fun fetchQuote(symbol: String): Quote? {
        val urlString = sources[currentSourceIndex].format(symbol.toUpperCase())
        return try {
            val url = URL(urlString)
            val conn = url.openConnection() as HttpURLConnection
            conn.requestMethod = "GET"
            conn.connectTimeout = 5000
            conn.readTimeout = 5000
            val reader = BufferedReader(InputStreamReader(conn.inputStream))
            val response = StringBuilder()
            reader.forEachLine { response.append(it) }
            reader.close()
            conn.disconnect()
            Quote().apply {
                setSymbol(symbol)
                setPrice(parsePrice(response.toString()))
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun parsePrice(html: String): Float {
        // Placeholder—adapt to actual HTML structure
        val marker = "$"
        val index = html.indexOf(marker)
        return if (index != -1) {
            val priceStr = html.substring(index + 1).split("[^0-9.]".toRegex())[0]
            priceStr.toFloat()
        } else 0f
    }

    private fun rotateSource() {
        currentSourceIndex = (currentSourceIndex + 1) % sources.size
    }

    override fun stopFetching() {
        fetchRunnable?.let { handler.removeCallbacks(it) }
    }
}
EOF

# Set permissions
chmod 644 "$STOCKS_API"

echo "StocksApi.kt has been restored at $STOCKS_API."
echo "Verifying content (first few lines):"
head -n 10 "$STOCKS_API"
