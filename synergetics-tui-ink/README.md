# Synergetics Dictionary TUI (Ink/React)

A Terminal User Interface for browsing and viewing the Synergetics Dictionary, built with [Ink](https://github.com/vadimdemedes/ink) (React for CLIs).

## Features

- **Browse cards** - Navigate through 21,000+ cards with keyboard shortcuts
- **View details** - See full card content, citations, and links
- **Search** - Find cards by title or content
- **Pagination** - Navigate through pages of results
- **Instant response** - All keyboard shortcuts work immediately

## Installation

```bash
cd synergetics-tui-ink
npm install
```

## Usage

### From the project root:

```bash
./run_tui_ink.sh
```

### From the synergetics-tui-ink directory:

```bash
npm start
```

Or directly:

```bash
node index.js
```

## Keyboard Shortcuts

### Card List View

- `j` or `↓` - Move down
- `k` or `↑` - Move up
- `Enter` - View selected card
- `/` - Search
- `n` - Next page
- `p` - Previous page
- `q` - Quit

### Card Detail View

- `b` or `←` - Back to list
- `q` - Quit

### Search View

- Type your query
- `Enter` - Search
- `Esc` - Cancel

## Technology Stack

- **Ink** - React-based framework for building terminal UIs
- **React** - Component-based UI library
- **better-sqlite3** - Fast SQLite database driver
- **Node.js** - JavaScript runtime

## Project Structure

```
synergetics-tui-ink/
├── index.js              # Main application entry point
├── database.js           # Database access layer
├── components/
│   ├── CardList.js       # Card list view component
│   ├── CardDetail.js     # Card detail view component
│   └── SearchInput.js    # Search input component
├── package.json          # Node.js package configuration
└── README.md            # This file
```

## Database

Connects to `../data/synergetics_dictionary.db` (SQLite database with 21,188 cards).

## Comparison with Elixir TUI

This Ink-based TUI provides similar functionality to the Elixir version but with:

- **Pros:**
  - Easier to build with React components
  - More familiar to JavaScript/React developers
  - Better cross-platform support
  - No TTY access issues (Ink handles terminal mode)

- **Cons:**
  - Slightly larger dependency footprint
  - Node.js required instead of Elixir/Erlang

## Development

Watch mode (auto-reload on changes):

```bash
npm run dev
```

## License

ISC

## Version

1.0.0 - Initial Release

