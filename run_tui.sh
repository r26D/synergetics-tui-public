#!/bin/bash
# Launcher script for Synergetics Dictionary TUI

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/synergetics_tui" || exit 1

# Check if database exists
if [ ! -f "../data/synergetics_dictionary.db" ]; then
    echo "Error: Database not found at data/synergetics_dictionary.db"
    echo "Please run: elixir scripts/import_cards_to_sqlite.exs"
    exit 1
fi

# Check if dependencies are installed and compile
if [ ! -d "deps" ] || [ ! -d "_build" ]; then
    echo "Installing dependencies..."
    mix deps.get
fi

# Always compile to ensure latest code
mix compile > /dev/null 2>&1

# Save current terminal settings
OLD_STTY=$(stty -g)

# Set raw mode on the terminal BEFORE launching Mix
# This is the key - we set it in bash where we have TTY access
stty -icanon -echo min 1 time 0

# Function to restore terminal on exit
cleanup() {
    stty "$OLD_STTY"
}

# Set trap to restore terminal on exit (normal or error)
trap cleanup EXIT INT TERM

# Run the TUI using Mix task
# The terminal is already in raw mode from the stty command above
mix tui

# cleanup will be called automatically by the trap

