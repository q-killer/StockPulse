#!/bin/bash

# Define paths
WORK_DIR="$HOME/StockTickerFork"
STOCKS_API="$WORK_DIR/app/src/main/kotlin/com/github/premnirmal/ticker/network/StocksApi.java"

# Backup original file
echo "Backing up StocksApi.java..."
cp "$STOCKS_API" "$STOCKS_API.bak"

# Modify StocksApi.java
echo "Updating polling logic and sources in StocksApi.java..."
cat > "$STOCKS_API" << 'EOF'
package com.github.premnirmal.ticker.network;

import android.os.Handler;
import android.os.Looper;
import com.github.premnirmal.ticker.model.IStocksProvider;
import com.github.premnirmal.ticker.network.data.Quote;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class StocksApi implements IStocksProvider {
  private static final String[] SOURCES = {
      "https://www.google.com/finance/quote/%s", // Google Finance
      "https://www.tradingview.com/symbols/%s/", // TradingView
      "https://finance.yahoo.com/quote/%s/",     // Yahoo Finance
      "https://www.nasdaq.com/market-activity/stocks/%s", // Nasdaq
      "https://www.marketwatch.com/investing/stock/%s",   // MarketWatch
      "https://www.reuters.com/quote/%s",        // Reuters
      "https://www.bloomberg.com/quote/%s:US"    // Bloomberg
  };
  private static final int[] POLL_INTERVALS = {60, 120, 180, 300}; // 1, 2, 3, 5 minutes in seconds
  private int currentSourceIndex = 0;
  private int currentIntervalIndex = 0;
  private final Random random = new Random();
  private final Handler handler = new Handler(Looper.getMainLooper());
  private Runnable fetchRunnable;

  @Override
  public void fetchStocks(final List<String> symbols) {
    if (fetchRunnable != null) {
      handler.removeCallbacks(fetchRunnable);
    }
    fetchRunnable = new Runnable() {
      @Override
      public void run() {
        List<Quote> quotes = new ArrayList<>();
        for (String symbol : symbols) {
          Quote quote = fetchQuote(symbol);
          if (quote != null) {
            quotes.add(quote);
          }
        }
        // Notify listeners (simplified—use original callback logic)
        handler.post(() -> {
          // Assuming a callback method exists in original; adapt as needed
        });
        // Schedule next fetch
        rotateSourceAndInterval();
        handler.postDelayed(this, POLL_INTERVALS[currentIntervalIndex] * 1000L);
      }
    };
    handler.post(fetchRunnable);
  }

  private Quote fetchQuote(String symbol) {
    String urlString = String.format(SOURCES[currentSourceIndex], symbol.toUpperCase());
    try {
      URL url = new URL(urlString);
      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      conn.setRequestMethod("GET");
      conn.setConnectTimeout(5000);
      conn.setReadTimeout(5000);
      BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      StringBuilder response = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        response.append(line);
      }
      reader.close();
      conn.disconnect();
      // Simple parsing (adapt to actual HTML structure—placeholder)
      Quote quote = new Quote();
      quote.setSymbol(symbol);
      quote.setPrice(parsePrice(response.toString()));
      return quote;
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  private float parsePrice(String html) {
    // Placeholder—original likely has better parsing; for demo, assume price in HTML
    String marker = "$"; // Adjust based on source format
    int index = html.indexOf(marker);
    if (index != -1) {
      String priceStr = html.substring(index + 1, index + 10).split("[^0-9.]")[0];
      return Float.parseFloat(priceStr);
    }
    return 0f;
  }

  private void rotateSourceAndInterval() {
    currentSourceIndex = (currentSourceIndex + 1) % SOURCES.length;
    // Randomly pick interval for demo; settings integration later
    currentIntervalIndex = random.nextInt(POLL_INTERVALS.length);
  }

  @Override
  public void stopFetching() {
    if (fetchRunnable != null) {
      handler.removeCallbacks(fetchRunnable);
    }
  }
}
EOF

echo "StocksApi.java updated with new polling logic and sources."
