#!/bin/bash

WORK_DIR="$HOME/StockTickerFork"
PREFS_PATH="$WORK_DIR/app/src/main/res/xml/prefs.xml"

echo "Backing up prefs.xml..."
cp "$PREFS_PATH" "$PREFS_PATH.bak"

echo "Adding polling interval and API key settings to prefs.xml..."
cat > "$PREFS_PATH" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<PreferenceScreen xmlns:android="http://schemas.android.com/apk/res/android">
    <ListPreference
        android:key="poll_interval"
        android:title="Polling Interval"
        android:summary="Set how often to fetch stock prices"
        android:entries="@array/poll_intervals"
        android:entryValues="@array/poll_interval_values"
        android:defaultValue="180" />
    <EditTextPreference
        android:key="api_key"
        android:title="Optional API Key"
        android:summary="Add a key for premium sources (e.g., Alpha Vantage)"
        android:defaultValue="" />
    <PreferenceCategory android:title="Widget Settings">
        <CheckBoxPreference
            android:key="hide_header"
            android:title="Hide Header"
            android:summary="Hide the widget header"
            android:defaultValue="false" />
    </PreferenceCategory>
</PreferenceScreen>
EOF

STRINGS_PATH="$WORK_DIR/app/src/main/res/values/strings.xml"
echo "Adding poll interval arrays to $STRINGS_PATH..."
sed -i '/<\/resources>/d' "$STRINGS_PATH"
cat >> "$STRINGS_PATH" << 'EOF'
    <string-array name="poll_intervals">
        <item>1 Minute</item>
        <item>2 Minutes</item>
        <item>3 Minutes</item>
        <item>5 Minutes</item>
    </string-array>
    <string-array name="poll_interval_values">
        <item>60</item>
        <item>120</item>
        <item>180</item>
        <item>300</item>
    </string-array>
</resources>
EOF

chmod 644 "$PREFS_PATH" "$STRINGS_PATH"
echo "Settings updated."
