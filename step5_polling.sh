#!/bin/bash

WORK_DIR="$HOME/StockTickerFork"

echo "Checking Java installation..."
if ! java -version 2>&1 | grep -q "17"; then
    echo "Installing OpenJDK 17..."
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk
fi
java -version

echo "Clearing caches for a fresh build..."
rm -rf "/home/isaac/.gradle/caches"/*
rm -rf "$WORK_DIR/app/build"/*

echo "Building project with Gradle..."
cd "$WORK_DIR" || exit
./gradlew clean build --scan > build_log.txt 2>&1 || {
    echo "Build failed! Check build_log.txt for details."
    exit 1
}

echo "Build attempt complete. Checking log for errors..."
cat build_log.txt | grep -i -e "error" -e "exception" -e "failed" -A 20 -B 20 > error_context.txt
echo "Errors (if any) saved to error_context.txt. Displaying below:"
cat error_context.txt
