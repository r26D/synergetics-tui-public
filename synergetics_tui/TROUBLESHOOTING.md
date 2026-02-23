# Synergetics Dictionary TUI - Troubleshooting

## NIF Loading Error (SOLVED)

### Problem

When running the escript version (`./synergetics_tui`), you may encounter this error:

```
[warning] The on_load function for module Elixir.Exqlite.Sqlite3NIF returned:
{:error, {:load_failed, "Failed to load NIF library: 'dlopen(...sqlite3_nif.so, 0x0002): tried: '...' (errno=20)..."}}

** (UndefinedFunctionError) function Exqlite.Sqlite3NIF.open/2 is undefined
```

### Root Cause

Escripts (Elixir's executable script format) have difficulty bundling and loading Native Implemented Functions (NIFs). Exqlite uses a NIF to interface with SQLite's C library, and the escript can't find the compiled `sqlite3_nif.so` file at runtime.

### Solution

**Use the Mix task instead of the escript:**

```bash
# From the synergetics_tui directory:
mix tui

# Or from the project root:
./run_tui.sh
```

The Mix task (`Mix.Tasks.Tui`) runs the TUI in the Mix environment where NIFs are properly loaded from the `_build/` directory.

### Technical Details

The fix involved:

1. **Created a Mix task** (`lib/mix/tasks/tui.ex`):
   ```elixir
   defmodule Mix.Tasks.Tui do
     use Mix.Task
     
     def run(_args) do
       Mix.Task.run("app.start")
       SynergeticsTui.TUI.start()
     end
   end
   ```

2. **Updated the launcher script** (`run_tui.sh`) to use `mix tui` instead of `./synergetics_tui`

3. **Updated documentation** to recommend the Mix task approach

### Why Not Fix the Escript?

While it's theoretically possible to bundle NIFs in escripts, it's complex and fragile:
- Requires custom NIF path configuration
- Platform-specific (different paths for macOS, Linux, Windows)
- Breaks easily with dependency updates
- The Mix task approach is simpler and more reliable

## Other Common Issues

### Database Not Found

**Error:**
```
Error: Database not found at ../data/synergetics_dictionary.db
```

**Solution:**
Run the import script from the project root:
```bash
elixir scripts/import_cards_to_sqlite.exs
```

### Dependencies Not Installed

**Error:**
```
** (Mix) Could not start application synergetics_tui
```

**Solution:**
Install dependencies:
```bash
cd synergetics_tui
mix deps.get
mix compile
```

### Compilation Errors

**Error:**
```
** (CompileError) lib/synergetics_tui/database.ex:...
```

**Solution:**
Clean and rebuild:
```bash
cd synergetics_tui
mix deps.clean --all
mix deps.get
mix compile
```

### Input Not Responding

**Issue:** Commands don't seem to work or nothing happens when you type

**Cause:** The TUI uses line-based input - **you must press Enter after each command**

**Solution:**
1. Type your command (e.g., `j` to move down)
2. **Press Enter**
3. The screen will update

Look for the yellow `Command>` prompt at the bottom of the screen. This is where you type your commands.

**Example:**
- To move down: Type `j` then press Enter
- To view a card: Just press Enter (no letter needed)
- To quit: Type `q` then press Enter

This is expected behavior for this simple TUI implementation. For instant character-by-character input, a more advanced terminal library like Ratatouille would be needed.

### Terminal Display Issues

**Issue:** Colors or formatting look wrong

**Possible causes:**
1. Terminal doesn't support ANSI colors
2. Terminal size is too small

**Solutions:**
- Use a modern terminal (iTerm2, Terminal.app, Alacritty, etc.)
- Resize terminal to at least 80x24 characters
- Check `TERM` environment variable is set (e.g., `xterm-256color`)

## Getting Help

If you encounter other issues:

1. **Check the logs:** Look for error messages in the terminal output
2. **Test the database:** Run `elixir synergetics_tui/test_startup.exs`
3. **Verify Elixir version:** Run `elixir --version` (need 1.18+)
4. **Check database file:** Run `ls -lh data/synergetics_dictionary.db`

## Development Issues

### Running Tests

```bash
cd synergetics_tui
mix test
```

### Debugging

Add `IO.inspect/2` calls to see state:

```elixir
# In lib/synergetics_tui/tui.ex
def run_loop(state) do
  IO.inspect(state, label: "Current State")
  # ... rest of function
end
```

### Recompiling After Changes

```bash
cd synergetics_tui
mix compile
mix tui
```

## Performance Issues

### Slow Startup

**Cause:** Loading 21,000+ cards takes time

**Normal behavior:** Should start in 1-2 seconds

**If slower:** Check database file isn't corrupted:
```bash
sqlite3 data/synergetics_dictionary.db "PRAGMA integrity_check;"
```

### Slow Search

**Cause:** Full-text search on large database

**Normal behavior:** Search should complete in < 1 second

**Optimization:** The database uses indexes on `title` and `content_text` fields

## Platform-Specific Issues

### macOS

- **Issue:** "Developer cannot be verified" warning
- **Solution:** Run `chmod +x run_tui.sh` and allow in System Preferences

### Linux

- **Issue:** Missing SQLite library
- **Solution:** Install SQLite: `sudo apt-get install sqlite3 libsqlite3-dev`

### Windows

- **Issue:** Script won't run
- **Solution:** Use PowerShell or WSL, or run directly: `cd synergetics_tui && mix tui`

## Still Having Issues?

Create a detailed bug report including:
- Elixir version (`elixir --version`)
- Operating system
- Full error message
- Steps to reproduce
- Output of `elixir synergetics_tui/test_startup.exs`

