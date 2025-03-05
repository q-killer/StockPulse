#!/bin/bash

# Define paths
WORK_DIR="$HOME/StockTickerFork"
STRINGS_PATH="$WORK_DIR/app/src/main/res/values/strings.xml"
BAK_DIR="$WORK_DIR/backups"
TEMP_DIR="/tmp/stockticker_temp"

# Backup current (broken) strings.xml
echo "Backing up current $STRINGS_PATH to $BAK_DIR/strings.xml.bak22..."
mkdir -p "$BAK_DIR"
cp "$STRINGS_PATH" "$BAK_DIR/strings.xml.bak22" 2>/dev/null || echo "No current strings.xml to backup."

# Download original strings.xml
echo "Downloading original strings.xml from premnirmal/StockTicker..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit
curl -L "https://raw.githubusercontent.com/premnirmal/StockTicker/master/app/src/main/res/values/strings.xml" -o strings.xml
mv strings.xml "$STRINGS_PATH"
cd "$WORK_DIR" || exit
rm -rf "$TEMP_DIR"

# Merge your custom strings
echo "Merging your custom strings into $STRINGS_PATH..."
sed -i '/<\/resources>/d' "$STRINGS_PATH"
cat >> "$STRINGS_PATH" << 'EOF'
    <string name="ok">OK</string>
    <string name="one_day">One Day</string>
    <string name="one_month">One Month</string>
    <string name="one_year">One Year</string>
    <string name="only_updates_on_weekdays">Only Updates on Weekdays</string>
    <string name="package_replaced_string">Package Replaced</string>
    <string name="please_rate">Please Rate</string>
    <string name="portfolio">Portfolio</string>
    <string name="privacy_policy">Privacy Policy</string>
    <string name="refresh_failed">Refresh Failed</string>
    <string name="refresh_on_screen_unlock">Refresh on Screen Unlock</string>
    <string name="refresh_on_screen_unlock_desc">Update widget when screen unlocks</string>
    <string name="refresh_updated_message">Refresh Updated</string>
    <string name="remove_holding">Remove Holding</string>
    <string name="remove_prompt">Remove?</string>
    <string name="round_two_dp">Round to Two Decimals</string>
    <string name="round_two_dp_desc">Display prices with two decimal places</string>
    <string name="set">Set</string>
    <string name="share_email_subject">Share Stock Ticker</string>
    <string name="skip">Skip</string>
    <string name="start_time">Start Time</string>
    <string name="start_time_updated">Start Time Updated</string>
    <string name="text_color_updated_message">Text Color Updated</string>
    <string name="text_size_updated_message">Text Size Updated</string>
    <string name="theme_updated_message">Theme Updated</string>
    <string name="three_month">Three Months</string>
    <string name="ticker_import_fail">Ticker Import Failed</string>
    <string name="ticker_import_success">Ticker Import Successful</string>
    <string name="total">Total</string>
    <string name="total_holdings">Total Holdings</string>
    <string name="two_weeks">Two Weeks</string>
    <string name="update_days">Update Days</string>
    <string name="update_days_desc">Days to check for updates</string>
    <string name="update_interval">Update Interval</string>
    <string name="widget_name_updated">Widget Name Updated</string>
    <string name="widget_width_updated_message">Widget Width Updated</string>
    <string name="yes">Yes</string>
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

# Validate XML
echo "Validating $STRINGS_PATH..."
if ! command -v xmllint >/dev/null 2>&1; then
    echo "Installing xmllint..."
    sudo apt-get install -y libxml2-utils
fi
xmllint --noout "$STRINGS_PATH" 2> xml_errors.txt || {
    echo "XML validation failed! Errors:"
    cat xml_errors.txt
    echo "Restoring backup and exiting—manual fix needed."
    cp "$BAK_DIR/strings.xml.bak22" "$STRINGS_PATH"
    exit 1
}
echo "XML is well-formed!"

# Set permissions
chmod 644 "$STRINGS_PATH"

# Clear build artifacts
echo "Clearing build artifacts..."
rm -rf "$WORK_DIR/app/build"/*

# Build project
echo "Rebuilding project with --scan..."
cd "$WORK_DIR" || exit
./gradlew clean build --scan > build_log.txt 2>&1 || {
    echo "Build failed! Check build_log.txt for details."
    exit 1
}

echo "Build attempt complete. Checking log for errors..."
cat build_log.txt | grep -i -e "error" -e "exception" -e "failed" -A 20 -B 20 > error_context.txt
echo "Errors (if any) saved to error_context.txt. Displaying below:"
cat error_context.txt
