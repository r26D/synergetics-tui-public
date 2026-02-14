#!/bin/bash
# Launcher script for Synergetics Dictionary TUI (Ink/React version)

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/synergetics-tui-ink" || exit 1

# Check if database exists
if [ ! -f "../data/synergetics_dictionary.db" ]; then
    echo "Error: Database not found at data/synergetics_dictionary.db"
    echo ""
    echo "Please create the sample database first:"
    echo "  cd .."
    echo "  elixir create_sample_database.exs"
    exit 1
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Run the TUI
npx tsx index.tsx

