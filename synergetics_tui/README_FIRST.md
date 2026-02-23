# 👋 READ THIS FIRST - Synergetics Dictionary TUI

## Quick Start

```bash
# From project root:
./run_tui.sh

# Or from synergetics_tui directory:
cd synergetics_tui
mix tui
```

## ⚡ IMPORTANT: ALL Input is INSTANT!

**Everything works instantly - no need to press Enter!**

### How It Works

Just press any key and it works immediately:
- Press `↓` - moves down instantly! ⚡
- Press `↑` - moves up instantly! ⚡
- Press `→` - views card instantly! ⚡
- Press `←` - goes back instantly! ⚡
- Press `j` - moves down instantly! ⚡
- Press `k` - moves up instantly! ⚡
- Press `q` - quits instantly! ⚡
- Type letters - they appear instantly! ⚡

**No more pressing Enter! Everything is instant!**

## Common Commands (All Instant! ⚡)

| Command | What It Does |
|---------|--------------|
| `↓` or `j` | Move down |
| `↑` or `k` | Move up |
| `→` or `Enter` | View card |
| `←` or `b` | Go back |
| `n` | Next page |
| `p` | Previous page |
| `/` | Search |
| `q` | Quit |

**All commands work instantly - no need to press Enter!**

## Why Press Enter?

This TUI uses "line-based input" - a simple approach that works everywhere but requires pressing Enter after each command. 

Think of it like a command-line interface: you type a command, press Enter, and see the result.

## Need More Help?

- **Detailed input guide**: See `INPUT_GUIDE.md`
- **Full documentation**: See `README.md`
- **Quick start**: See `QUICKSTART_TUI.md` in project root
- **Troubleshooting**: See `TROUBLESHOOTING.md`

## First Time Using?

Try this:

1. Start the TUI: `./run_tui.sh`
2. You'll see a list of cards
3. Press `↓` - cursor moves down **instantly!** ⚡
4. Press `↑` - cursor moves up **instantly!** ⚡
5. Press `→` or `Enter` - you see card details **instantly!** ⚡
6. Press `←` or `b` - back to list **instantly!** ⚡
7. Press `q` - quit **instantly!** ⚡

That's it! Everything works instantly - no need to press Enter!

**Pro tip:** Use arrow keys or vim keys (j/k) - both work great!

## Features

- ✅ Browse 21,000+ dictionary cards
- ✅ View full card details
- ✅ Search by title or content
- ✅ Edit card fields
- ✅ Color-coded display
- ✅ Pagination (20 cards per page)

## What You'll See

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================
  Synergetics Dictionary TUI - 21188 cards loaded

Cards 1-20 of 21188

► C00001 - A                          ← Selected card (green arrow)
  C00002 - AAB Complex Three-quanta Module
  C00003 - A & B Quanta Modules
  ...

--------------------------------------------------------------------------------
  j/k: Navigate  Enter: View  /: Search  n/p: Next/Prev Page  q: Quit
  (Type command and press Enter)      ← Reminder!

Command> _                             ← Type here!
```

## Troubleshooting

**Nothing happens when I type?**
→ Did you press Enter? You must press Enter after each command.

**Database not found?**
→ Run: `elixir scripts/import_cards_to_sqlite.exs` from project root

**NIF loading error?**
→ Use `mix tui` instead of the escript

See `TROUBLESHOOTING.md` for more help.

## Ready?

Start the TUI and try it out:

```bash
./run_tui.sh
```

Remember: **Type command → Press Enter → See result**

Happy browsing! 🎯

