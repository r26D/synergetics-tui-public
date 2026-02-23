#!/bin/bash

# Synergetics Dictionary TUI (Ink/React version)
# Launcher script

# Increase Node.js memory limit to prevent heap out of memory errors
export NODE_OPTIONS="--max-old-space-size=4096"

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/synergetics-tui-ink" || exit 1

# Check if database exists
if [ ! -f "../data/synergetics_dictionary.db" ]; then
    echo "Error: Database not found at data/synergetics_dictionary.db"
    exit 1
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Run the TUI
npx tsx index.tsx

