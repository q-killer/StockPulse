#!/bin/bash

WORK_DIR="$HOME/StockTickerFork"
ORIG_REPO="https://github.com/premnirmal/StockTicker.git"

echo "Removing old project directory if it exists..."
rm -rf "$WORK_DIR"

echo "Cloning original StockTicker project..."
git clone "$ORIG_REPO" "$WORK_DIR"
cd "$WORK_DIR" || exit

echo "Project cloned to $WORK_DIR. Current branch:"
git branch
