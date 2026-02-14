# Synergetics Dictionary TUI (Ink/React)

A Terminal User Interface for browsing and viewing the Synergetics Dictionary, built with [Ink](https://github.com/vadimdemedes/ink) (React for CLIs).

## Features

- **Browse cards** - Navigate through 21,000+ cards with keyboard shortcuts
- **View details** - See full card content, citations, and links
- **Search** - Find cards by title or content
- **Pagination** - Navigate through pages of results
- **Instant response** - All keyboard shortcuts work immediately

## Prerequisites

- Node.js 18 or later
- npm
- The Synergetics Dictionary database at `../data/synergetics_dictionary.db`

## Installation

```bash
npm install
```

## Usage

### From the project root:

```bash
./run_tui_ink.sh
```

### From this directory:

```bash
npm start
```

Or directly:

```bash
node index.js
```

### Development mode (with watch):

```bash
npm run dev
```

## Keyboard Shortcuts

### List Mode (browsing cards)
- `↑` / `↓` - Navigate up/down through cards
- `Enter` - View selected card details
- `/` - Search for cards
- `n` - Next page
- `p` - Previous page
- `r` - Refresh card list
- `q` - Quit

### Detail Mode (viewing a card)
- `Esc` or `b` - Back to list
- `q` - Quit

### Search Mode
- Type your query
- `Enter` - Submit search
- `Esc` - Cancel search

## Architecture

The TUI is built with:
- **Ink 6.7.0** - React for terminal UIs
- **React 19.2.4** - Component framework
- **better-sqlite3** - SQLite database driver
- **tsx** - TypeScript/JSX transpiler for Node.js
- **ES Modules** - Modern JavaScript

### Components

- `CardList` - Displays paginated list of cards with navigation
- `CardDetail` - Shows full card details including content and links
- `SearchInput` - Handles search query input

### Database Layer

- `database.js` - Provides functions for:
  - `countCards()` - Get total card count
  - `listCards(query, limit, offset)` - Get paginated card list
  - `getCard(id)` - Get full card details with links and citations
  - `closeDatabase()` - Clean up database connection

## Development

The application uses:
- **TypeScript/JSX** via tsx for modern syntax
- **ES Modules** for clean imports
- **React hooks** for state management
- **Ink components** for terminal rendering

## Notes

- This is a read-only TUI (no editing capabilities)
- All keyboard shortcuts work instantly without pressing Enter
- The database path is relative: `../data/synergetics_dictionary.db`
- Uses better-sqlite3 for synchronous database access

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

### Module Not Found

If you see module errors, make sure dependencies are installed:
```bash
npm install
```

### TypeScript Errors

The project uses tsx which handles TypeScript/JSX automatically. No compilation step needed.

## Technology Stack

- **Runtime**: Node.js with tsx
- **UI Framework**: Ink (React for CLIs)
- **Database**: better-sqlite3
- **Language**: TypeScript/JSX (ES Modules)

## Performance

- Instant keyboard response
- Efficient pagination (loads only visible cards)
- Synchronous database queries for simplicity
- Minimal dependencies

