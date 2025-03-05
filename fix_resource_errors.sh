#!/bin/bash

# Define paths
WORK_DIR="$HOME/StockTickerFork"
RES_DIR="$WORK_DIR/app/src/main/res"
STRINGS_PATH="$RES_DIR/values/strings.xml"
PREFS_PATH="$RES_DIR/xml/prefs.xml"
BAK_DIR="$WORK_DIR/backups"

# Create backup directory
echo "Creating backup directory at $BAK_DIR..."
mkdir -p "$BAK_DIR"

# Move .bak files out of res/
echo "Moving .bak files to $BAK_DIR..."
find "$RES_DIR" -name "*.bak" -exec mv {} "$BAK_DIR/" \; -exec echo "Moved: {}" \;

# Backup current strings.xml
echo "Backing up $STRINGS_PATH to $BAK_DIR/strings.xml.bak20..."
cp "$STRINGS_PATH" "$BAK_DIR/strings.xml.bak20"

# Fix duplicate arrays in strings.xml
echo "Removing duplicate poll_intervals and poll_interval_values arrays..."
# Extract all arrays, keep only the last occurrence of each
awk '
  BEGIN { in_array = 0; array_name = ""; content = "" }
  /<string-array name="poll_intervals"/ { in_array = 1; array_name = "poll_intervals"; content = ""; next }
  /<string-array name="poll_interval_values"/ { in_array = 1; array_name = "poll_interval_values"; content = ""; next }
  /<\/string-array>/ && in_array { 
    in_array = 0; 
    arrays[array_name] = content $0; 
    next 
  }
  in_array { content = content $0 "\n" }
  { if (!in_array) print $0 }
  END { 
    for (name in arrays) print arrays[name] 
  }
' "$STRINGS_PATH" > "$STRINGS_PATH.tmp"
mv "$STRINGS_PATH.tmp" "$STRINGS_PATH"

# Ensure proper formatting
sed -i '/<\/resources>/d' "$STRINGS_PATH"
echo "</resources>" >> "$STRINGS_PATH"
chmod 644 "$STRINGS_PATH"

# Verify strings.xml
echo "Checking $STRINGS_PATH for poll_intervals..."
grep -A 5 "poll_intervals" "$STRINGS_PATH"

# Clear build artifacts (cache already cleared in previous runs)
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
