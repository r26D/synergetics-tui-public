# Synergetics Dictionary TUI

Two Terminal User Interface (TUI) applications for browsing the Synergetics Dictionary database - one built with Elixir, one with TypeScript/React/Ink.

## 🎯 Overview

This repository contains two different implementations of a TUI for browsing dictionary cards stored in a SQLite database:

1. **Elixir TUI** (`synergetics_tui/`) - Built with Elixir and raw terminal control
2. **Ink TUI** (`synergetics-tui-ink/`) - Built with TypeScript, React, and Ink framework

Both TUIs provide:
- Browse 21,000+ dictionary cards with pagination
- Search cards by title or content
- View full card details including cross-references and citations
- Keyboard navigation with vim-style shortcuts

## 🚀 Quick Start

### Prerequisites

**For Elixir TUI:**
- Elixir 1.18 or later
- SQLite3 command-line tool

**For Ink TUI:**
- Node.js 18 or later
- npm

### Setup

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd synergetics-tui-public
   ```

2. **Create the sample database:**
   ```bash
   elixir create_sample_database.exs
   ```
   
   This creates `data/synergetics_dictionary.db` with 15 sample cards for testing.

3. **Run either TUI:**

   **Elixir TUI:**
   ```bash
   ./run_tui.sh
   ```

   **Ink TUI:**
   ```bash
   ./run_tui_ink.sh
   ```

## 📖 Usage

### Elixir TUI

**Keyboard Shortcuts:**
- `j` / `↓` - Move down
- `k` / `↑` - Move up
- `n` / `→` - Next page
- `p` / `←` - Previous page
- `Enter` - View card details
- `/` - Search
- `e` - Edit card (in detail view)
- `Esc` / `b` - Go back
- `q` - Quit

**Features:**
- Line-based input (press Enter after each command)
- ANSI color formatting
- Full-text search
- Card editing capabilities

### Ink TUI

**Keyboard Shortcuts:**
- `↑` / `↓` - Navigate cards
- `Enter` - View card details
- `/` - Search
- `n` - Next page
- `p` - Previous page
- `r` - Refresh
- `Esc` / `b` - Go back
- `q` - Quit

**Features:**
- Instant keyboard response
- React-based component architecture
- Beautiful terminal UI with Ink
- Read-only browsing

## 🗂️ Database Schema

The SQLite database contains the following tables:

- **cards** - Main card data (id, title, content, type, etc.)
- **see_links** - Cross-references between cards
- **citations** - Bibliographic citations
- **section_refs** - Synergetics section number references
- **card_aliases** - Alternate names for cards
- **cards_fts** - Full-text search index (FTS5)

See `data/schema.sql` for the complete schema.

## 📁 Repository Structure

```
synergetics-tui-public/
├── README.md                      # This file
├── create_sample_database.exs     # Script to create sample database
├── run_tui.sh                     # Launcher for Elixir TUI
├── run_tui_ink.sh                 # Launcher for Ink TUI
├── data/
│   ├── schema.sql                 # Database schema
│   └── synergetics_dictionary.db  # SQLite database (created by script)
├── synergetics_tui/               # Elixir TUI
│   ├── lib/                       # Source code
│   ├── test/                      # Tests
│   ├── mix.exs                    # Elixir project config
│   └── mix.lock                   # Dependency lock file
└── synergetics-tui-ink/           # Ink TUI
    ├── components/                # React components
    ├── index.tsx                  # Main application
    ├── database.js                # Database access layer
    ├── package.json               # Node.js project config
    └── package-lock.json          # Dependency lock file
```

## 🔧 Development

### Elixir TUI

```bash
cd synergetics_tui
mix deps.get      # Install dependencies
mix compile       # Compile
mix test          # Run tests
mix tui           # Run TUI
```

### Ink TUI

```bash
cd synergetics-tui-ink
npm install       # Install dependencies
npm start         # Run TUI
npm run dev       # Run with watch mode
```

## 🐛 Troubleshooting

### Database not found
If you see "Database not found", run:
```bash
elixir create_sample_database.exs
```

### Elixir TUI: NIF loading error
Use `mix tui` instead of the escript. The launcher script (`run_tui.sh`) handles this automatically.

### Ink TUI: Module not found
Make sure you've run `npm install` in the `synergetics-tui-ink` directory.

## 📝 Using Your Own Database

To use a full Synergetics Dictionary database instead of the sample:

1. Place your `synergetics_dictionary.db` file in the `data/` directory
2. Ensure it follows the schema in `data/schema.sql`
3. Run either TUI normally

The database should contain cards with the following structure:
- Card IDs: C00001 through C21188 (or any range)
- Required fields: id, card_number, title, letter_group, volume, card_type, content_text

## 📄 License

[Add your license here]

## 🤝 Contributing

Contributions welcome! Please feel free to submit issues or pull requests.

## 🙏 Acknowledgments

Built for the Synergetics Dictionary project, based on R. Buckminster Fuller's work.

