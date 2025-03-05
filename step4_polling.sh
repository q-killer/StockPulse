#!/bin/bash

WORK_DIR="$HOME/StockTickerFork"
APP_PREFS="$WORK_DIR/app/src/main/kotlin/com/github/premnirmal/ticker/AppPreferences.java"

echo "Backing up AppPreferences.java..."
cp "$APP_PREFS" "$APP_PREFS.bak"

echo "Updating AppPreferences.java..."
cat > "$APP_PREFS" << 'EOF'
package com.github.premnirmal.ticker;

import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;
import com.github.premnirmal.tickerwidget.R;

public class AppPreferences {
  private static AppPreferences instance;
  private final SharedPreferences preferences;

  private AppPreferences() {
    preferences = PreferenceManager.getDefaultSharedPreferences(Injector.getAppContext());
  }

  public static AppPreferences getInstance() {
    if (instance == null) {
      instance = new AppPreferences();
    }
    return instance;
  }

  public int getPollInterval() {
    return Integer.parseInt(preferences.getString("poll_interval", "180"));
  }

  public String getApiKey() {
    return preferences.getString("api_key", "");
  }

  public boolean isHideHeader() {
    return preferences.getBoolean("hide_header", false);
  }

  public void setHideHeader(boolean hide) {
    Editor editor = preferences.edit();
    editor.putBoolean("hide_header", hide);
    editor.apply();
  }
}
EOF

echo "AppPreferences.java updated."
