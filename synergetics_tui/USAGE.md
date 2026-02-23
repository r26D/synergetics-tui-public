# Synergetics Dictionary TUI - Usage Guide

## Quick Start

From the project root directory:

```bash
./run_tui.sh
```

Or from the `synergetics_tui` directory:

```bash
./synergetics_tui
```

## Interface Overview

The TUI has four main modes:

### 1. List Mode (Default)
Browse through all cards with pagination.

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================
  Synergetics Dictionary TUI - 21188 cards loaded

Cards 1-20 of 21188

► C00001 - A
  C00002 - Abacus
  C00003 - Aberration
  ...

--------------------------------------------------------------------------------
  ↑/↓: Navigate  Enter: View  /: Search  n/p: Next/Prev Page  q: Quit
```

**Controls:**
- `↑` or `k`: Move selection up
- `↓` or `j`: Move selection down
- `n`: Next page (20 cards)
- `p`: Previous page
- `Enter`: View selected card details
- `/`: Enter search mode
- `q`: Quit application

### 2. Detail Mode
View full details of a selected card.

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================

Card: C00123
Title: Acceleration: Angular and Linear Acceleration
Type: definition | Group: a | Volume: 1
Reference Level: (1)

Content:
--------------------------------------------------------------------------------
DEFINITIONS

"Acceleration: Angular and Linear Acceleration
...

See Links (3):
  → Angular Acceleration (C00456)
  → Linear Acceleration (C01234)
  → Velocity (C05678)

Citations (2):
  • Synergetics 1, Section 123.45
  • Letter to John Doe, 1965

--------------------------------------------------------------------------------
  e: Edit  b: Back to list  q: Quit
```

**Controls:**
- `e`: Enter edit mode
- `b`: Back to list
- `q`: Quit application

### 3. Edit Mode
Edit card fields.

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================

Editing Card: C00123

1. Title: Acceleration: Angular and Linear Acceleration
2. Content Text: DEFINITIONS "Acceleration: Angular and Linear...
3. Definition Text: Acceleration: Angular and Linear Acceleration...

Select a field to edit (1-3)

--------------------------------------------------------------------------------
  1-3: Select field  s: Save  c: Cancel  b: Back
```

**Controls:**
- `1`: Edit title
- `2`: Edit content text
- `3`: Edit definition text
- Type text to append to the selected field
- `s`: Save changes to database
- `c`: Cancel editing
- `b`: Back to detail view

**Note:** The current implementation appends text. For full editing, you'll need to manually clear and retype the field content.

### 4. Search Mode
Search for cards by title or content.

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================

Search Cards

Query: acceleration_

Results (5):

► C00123 - Acceleration: Angular and Linear Acceleration
  C00456 - Angular Acceleration
  C01234 - Linear Acceleration
  C02345 - Deceleration
  C03456 - Velocity and Acceleration

--------------------------------------------------------------------------------
  Type to search  Enter: View selected  Esc: Back to list
```

**Controls:**
- Type to search (minimum 2 characters)
- `↑`/`↓` or `k`/`j`: Navigate results
- `Enter`: View selected card
- `b`: Back to list mode

## Tips

1. **Navigation**: Use vim-style `j`/`k` keys or arrow keys for navigation
2. **Quick Search**: Press `/` from list mode to quickly search
3. **Pagination**: With 21,000+ cards, use search to find specific cards quickly
4. **Editing**: The edit mode is basic - for complex edits, consider using SQL directly

## Database Schema

The TUI reads from and writes to the SQLite database with the following main fields:

- `id`: Card ID (e.g., C00001)
- `title`: Card title
- `content_text`: Full card content
- `definition_text`: Definition portion (for definition cards)
- `card_type`: Type of card (definition, text_citation, cross_reference, term)
- `cross_references`: Cross-references to other cards
- `citations`: Bibliographic citations

## Troubleshooting

### Database Not Found
```
Error: Database not found at ../data/synergetics_dictionary.db
```

**Solution:** Run the import script from the project root:
```bash
elixir scripts/import_cards_to_sqlite.exs
```

### Compilation Errors
If you encounter compilation errors, try:
```bash
cd synergetics_tui
mix deps.clean --all
mix deps.get
mix compile
mix escript.build
```

### Input Not Working
The TUI uses line-based input (press Enter after each command). This is a limitation of the simple implementation. For character-by-character input, a more advanced terminal library would be needed.

## Future Enhancements

Potential improvements for the TUI:

1. **Better Input Handling**: Use a proper terminal library for character-by-character input
2. **Full-Screen Editing**: Multi-line text editor for content fields
3. **Syntax Highlighting**: Highlight LaTeX commands in content
4. **Link Navigation**: Jump to linked cards directly from detail view
5. **Filtering**: Filter by card type, letter group, or volume
6. **Export**: Export selected cards to various formats
7. **Undo/Redo**: Track changes and allow reverting

## Contributing

To add features or fix bugs:

1. Edit the relevant module in `lib/synergetics_tui/`
2. Run tests: `mix test`
3. Rebuild: `mix compile && mix escript.build`
4. Test your changes

## License

Same as the Synergetics Dictionary project.

