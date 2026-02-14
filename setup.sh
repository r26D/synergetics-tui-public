#!/bin/bash
# Quick setup script for Synergetics Dictionary TUI
#
# Usage:
#   ./setup.sh                                    # Create minimal sample database
#   ./setup.sh /path/to/synergetics_dictionary.db # Copy letter group 'a' from source

set -e

SOURCE_DB="$1"

echo "========================================="
echo "Synergetics Dictionary TUI - Setup"
echo "========================================="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check for Elixir
if command -v elixir &> /dev/null; then
    ELIXIR_VERSION=$(elixir --version | grep "Elixir" | awk '{print $2}')
    echo "✓ Elixir found: $ELIXIR_VERSION"
    HAS_ELIXIR=true
else
    echo "✗ Elixir not found (required for Elixir TUI)"
    HAS_ELIXIR=false
fi

# Check for Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js found: $NODE_VERSION"
    HAS_NODE=true
else
    echo "✗ Node.js not found (required for Ink TUI)"
    HAS_NODE=false
fi

# Check for SQLite3
if command -v sqlite3 &> /dev/null; then
    SQLITE_VERSION=$(sqlite3 --version | awk '{print $1}')
    echo "✓ SQLite3 found: $SQLITE_VERSION"
    HAS_SQLITE=true
else
    echo "✗ SQLite3 not found (required for database creation)"
    HAS_SQLITE=false
fi

echo ""

# Create database if it doesn't exist
if [ ! -f "data/synergetics_dictionary.db" ]; then
    if [ "$HAS_ELIXIR" = true ] && [ "$HAS_SQLITE" = true ]; then
        if [ -n "$SOURCE_DB" ]; then
            if [ -f "$SOURCE_DB" ]; then
                echo "Creating database with letter group 'a' from: $SOURCE_DB"
                elixir create_sample_database.exs "$SOURCE_DB"
            else
                echo "⚠ Source database not found: $SOURCE_DB"
                echo "Creating minimal sample database instead..."
                elixir create_sample_database.exs
            fi
        else
            echo "Creating minimal sample database..."
            echo "(To include full letter group 'a', run: ./setup.sh /path/to/synergetics_dictionary.db)"
            elixir create_sample_database.exs
        fi
        echo ""
    else
        echo "⚠ Cannot create database: Elixir and SQLite3 are required"
        echo ""
    fi
else
    echo "✓ Database already exists at data/synergetics_dictionary.db"
    echo ""
fi

# Setup Elixir TUI
if [ "$HAS_ELIXIR" = true ]; then
    echo "Setting up Elixir TUI..."
    (cd synergetics_tui && mix deps.get && mix compile)
    echo "✓ Elixir TUI ready"
    echo ""
else
    echo "⚠ Skipping Elixir TUI setup (Elixir not found)"
    echo ""
fi

# Setup Ink TUI
if [ "$HAS_NODE" = true ]; then
    echo "Setting up Ink TUI..."
    (cd synergetics-tui-ink && npm install)
    echo "✓ Ink TUI ready"
    echo ""
else
    echo "⚠ Skipping Ink TUI setup (Node.js not found)"
    echo ""
fi

# Summary
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""

if [ "$HAS_ELIXIR" = true ] && [ -f "data/synergetics_dictionary.db" ]; then
    echo "To run the Elixir TUI:"
    echo "  ./run_tui.sh"
    echo ""
fi

if [ "$HAS_NODE" = true ] && [ -f "data/synergetics_dictionary.db" ]; then
    echo "To run the Ink TUI:"
    echo "  ./run_tui_ink.sh"
    echo ""
fi

if [ "$HAS_ELIXIR" = false ] || [ "$HAS_NODE" = false ] || [ "$HAS_SQLITE" = false ]; then
    echo "⚠ Some prerequisites are missing. Please install:"
    [ "$HAS_ELIXIR" = false ] && echo "  - Elixir: https://elixir-lang.org/install.html"
    [ "$HAS_NODE" = false ] && echo "  - Node.js: https://nodejs.org/"
    [ "$HAS_SQLITE" = false ] && echo "  - SQLite3: https://www.sqlite.org/download.html"
    echo ""
fi

echo "For more information, see README.md"

