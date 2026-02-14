# Synergetics Dictionary TUI (Elixir)

A Terminal User Interface (TUI) for browsing and editing cards from the Synergetics Dictionary database, built with Elixir.

## Features

- **Browse Cards**: Navigate through all dictionary cards with pagination
- **View Details**: See full card content including:
  - Title, type, letter group, volume
  - Content text and definition text
  - See links (cross-references)
  - Citations
- **Search**: Search cards by title or content
- **Edit Cards**: Edit card fields (title, content_text, definition_text)
- **Keyboard Navigation**: Vim-style navigation (j/k) and intuitive shortcuts

## Prerequisites

- Elixir 1.18 or later
- The Synergetics Dictionary database at `../data/synergetics_dictionary.db`

## Installation

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Compile the project:
   ```bash
   mix compile
   ```

## Usage

### From the project root:
```bash
./run_tui.sh
```

### From this directory:
```bash
mix tui
```

## Keyboard Shortcuts

### List Mode (browsing cards)
- `j` or `↓` - Move down
- `k` or `↑` - Move up
- `n` or `→` - Next page
- `p` or `←` - Previous page
- `Enter` - View selected card details
- `/` - Enter search mode
- `q` - Quit

### Detail Mode (viewing a card)
- `e` - Enter edit mode
- `Esc` or `b` - Back to list
- `q` - Quit

### Edit Mode
- `1` - Edit title
- `2` - Edit content
- `3` - Edit definition
- `s` - Save changes
- `Esc` or `c` - Cancel (back to detail view)

### Search Mode
- Type your query and press `Enter`
- `Esc` - Cancel search

## Architecture

The TUI is built with:
- **Exqlite**: SQLite database access
- **IO.ANSI**: Terminal colors and formatting
- **Simple input loop**: Character-by-character input handling

### Modules

- `SynergeticsTui.Database`: Database queries and operations
- `SynergeticsTui.TUI`: Main UI rendering and loop
- `SynergeticsTui.InputHandler`: Input event handling and state updates

## Development

Run tests:
```bash
mix test
```

Format code:
```bash
mix format
```

## Notes

- The TUI uses a simple line-based input system (press Enter after each command)
- The database path is relative to the TUI directory: `../data/synergetics_dictionary.db`
- Use `mix tui` instead of the escript due to NIF loading requirements

## Troubleshooting

### Database Not Found
```
Error: Database not found at ../data/synergetics_dictionary.db
```

**Solution:** Create the sample database from the project root:
```bash
cd ..
elixir create_sample_database.exs
```

### Compilation Errors
If you encounter compilation errors, try:
```bash
mix deps.clean --all
mix deps.get
mix compile
```

### Terminal Issues
If the terminal doesn't respond properly, make sure you're using the launcher script which sets up the terminal correctly:
```bash
cd ..
./run_tui.sh
```

