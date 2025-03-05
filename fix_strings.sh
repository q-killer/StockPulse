#!/bin/bash

# Define paths
WORK_DIR="$HOME/StockTickerFork"
STRINGS_PATH="$WORK_DIR/app/src/main/res/values/strings.xml"
BAK_DIR="$WORK_DIR/backups"

# Backup current strings.xml
echo "Backing up $STRINGS_PATH to $BAK_DIR/strings.xml.bak21..."
mkdir -p "$BAK_DIR"
cp "$STRINGS_PATH" "$BAK_DIR/strings.xml.bak21"

# Inspect around line 232
echo "Checking lines around 232 in $STRINGS_PATH before fix:"
sed -n '227,237p' "$STRINGS_PATH"

# Fix strings.xml by removing everything after last </resources> and ensuring closure
echo "Fixing $STRINGS_PATH formatting..."
awk '
  BEGIN { in_resources = 0; content = "" }
  /<resources>/ { in_resources++; if (in_resources == 1) content = $0 "\n"; next }
  /<\/resources>/ && in_resources > 0 { 
    content = content $0 "\n"; 
    in_resources--; 
    if (in_resources == 0) { print content; exit } 
    next 
  }
  in_resources > 0 { content = content $0 "\n" }
' "$STRINGS_PATH" > "$STRINGS_PATH.tmp"
mv "$STRINGS_PATH.tmp" "$STRINGS_PATH"

# Ensure exactly one </resources> at the end
if ! grep -q "</resources>" "$STRINGS_PATH"; then
    echo "</resources>" >> "$STRINGS_PATH"
fi
chmod 644 "$STRINGS_PATH"

# Verify fix
echo "Checking lines around 232 after fix:"
tail -n 10 "$STRINGS_PATH"

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
