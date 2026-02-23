# Synergetics Dictionary TUI

A Terminal User Interface (TUI) for browsing and editing cards from the Synergetics Dictionary database.

## Features

- **Browse Cards**: Navigate through all 21,000+ dictionary cards with pagination
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
  - Run `elixir scripts/import_cards_to_sqlite.exs` from the project root to create the database

## Installation

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Compile the project:
   ```bash
   mix compile
   ```

3. Build the executable:
   ```bash
   mix escript.build
   ```

## Usage

**Recommended:** Run the TUI using the Mix task:

```bash
mix tui
```

Or from the project root:

```bash
./run_tui.sh
```

**Note:** The escript version (`./synergetics_tui`) has issues with NIF loading. Use the Mix task instead.

## ⚡ Important: ALL Input is Instant!

**The TUI uses character-by-character input - everything works instantly!**

- Just press any key - no need to press Enter!
- Arrow keys work instantly (↑/↓/←/→)
- Letter commands work instantly (j/k/n/p/q/e/b)
- Type to search - characters appear instantly
- Backspace works in search and edit modes

**No more waiting, no more pressing Enter!** The TUI responds immediately to every keypress.

## Keyboard Shortcuts (All Instant! ⚡)

### List View (Browse Cards)
- `↑` or `k`: Move up
- `↓` or `j`: Move down
- `→` or `Enter`: View selected card
- `n`: Next page
- `p`: Previous page
- `/`: Search cards
- `q`: Quit

**All commands work instantly - no need to press Enter!**

### Detail View (Card Details)
- `←` or `b`: Back to list
- `e`: Edit card
- `q`: Quit

### Edit View
- `1-3`: Select field to edit (1=Title, 2=Content, 3=Definition)
- Type to add text to the selected field
- `s`: Save changes
- `c`: Cancel editing
- `b`: Back to detail view

### Search View
- Type to search
- `↑`/`↓` or `k`/`j`: Navigate results
- `Enter`: View selected card
- `b`: Back to list

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
- For better terminal control, consider using a library like Ratatouille in the future
- The database path is relative to the TUI directory: `../data/synergetics_dictionary.db`

## License

Same as the Synergetics Dictionary project.

