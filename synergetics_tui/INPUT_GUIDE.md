# TUI Input Guide - How to Use the Keyboard Controls

## 🔑 The Key Thing to Remember

**You must press Enter after every command!**

This TUI uses "line-based input" which means:
1. Type a command letter
2. Press Enter
3. See the result

## Visual Example

Here's what you'll see:

```
================================================================================
  SYNERGETICS DICTIONARY TUI
================================================================================
  Synergetics Dictionary TUI - 21188 cards loaded

Cards 1-20 of 21188

► C00001 - A
  C00002 - AAB Complex Three-quanta Module
  C00003 - A & B Quanta Modules
  ...

--------------------------------------------------------------------------------
  j/k: Navigate  Enter: View  /: Search  n/p: Next/Prev Page  q: Quit
  (Type command and press Enter)

Command> _
```

The yellow `Command>` prompt is where you type.

## Step-by-Step Examples

### Example 1: Move Down One Card

**Option A: Using arrow keys**
1. You see the cursor on "C00001 - A"
2. Press: `↓` (down arrow)
3. Press: `Enter`
4. Result: Cursor moves to "C00002 - AAB Complex Three-quanta Module"

**Option B: Using vim keys**
1. You see the cursor on "C00001 - A"
2. Type: `j`
3. Press: `Enter`
4. Result: Cursor moves to "C00002 - AAB Complex Three-quanta Module"

### Example 2: View a Card

1. Navigate to the card you want (using `j`/`k`)
2. Don't type anything, just press: `Enter`
3. Result: You see the full card details

### Example 3: Search for a Card

1. Type: `/`
2. Press: `Enter`
3. Result: You enter search mode
4. Type: `acceleration`
5. Press: `Enter`
6. Result: You see search results

### Example 4: Go to Next Page

1. Type: `n`
2. Press: `Enter`
3. Result: You see cards 21-40

### Example 5: Quit

1. Type: `q`
2. Press: `Enter`
3. Result: TUI exits

## Complete Command Reference

### In List Mode (Browsing Cards)

| What to Type/Press | Then Press | What Happens |
|--------------------|------------|--------------|
| `↓` or `j` | Enter | Move down one card |
| `↑` or `k` | Enter | Move up one card |
| `n` | Enter | Next page (20 cards) |
| `p` | Enter | Previous page |
| (nothing) | Enter | View selected card |
| `/` | Enter | Enter search mode |
| `q` | Enter | Quit the TUI |

**Tip:** Arrow keys work! Use ↑/↓ if you prefer them over j/k.

### In Detail Mode (Viewing a Card)

| What to Type | Then Press | What Happens |
|--------------|------------|--------------|
| `e` | Enter | Edit this card |
| `b` | Enter | Back to list |
| `q` | Enter | Quit the TUI |

### In Edit Mode

| What to Type | Then Press | What Happens |
|--------------|------------|--------------|
| `1` | Enter | Select title field |
| `2` | Enter | Select content field |
| `3` | Enter | Select definition field |
| (any text) | Enter | Add text to selected field |
| `s` | Enter | Save changes |
| `c` | Enter | Cancel (don't save) |
| `b` | Enter | Back to detail view |

### In Search Mode

| What to Type/Press | Then Press | What Happens |
|--------------------|------------|--------------|
| (search text) | Enter | Search for cards |
| `↓` or `j` | Enter | Move down in results |
| `↑` or `k` | Enter | Move up in results |
| (nothing) | Enter | View selected result |
| `b` | Enter | Back to list |

## Why Does It Work This Way?

This TUI uses Elixir's `IO.gets/1` function, which reads a full line of input. This is simpler to implement but requires pressing Enter.

**Advantages:**
- ✅ Simple, no external dependencies
- ✅ Works on any terminal
- ✅ Easy to understand and modify
- ✅ Arrow keys work (as of latest update!)

**Disadvantages:**
- ❌ Requires pressing Enter (not instant)
- ❌ No mouse support

## Alternative: Ratatouille

For instant character-by-character input (like vim or htop), the TUI would need to be rewritten using a library like Ratatouille. This was the original plan but had build issues.

If you want to contribute this enhancement, see the project README for details!

## Tips for Faster Navigation

1. **Use `n`/`p` for big jumps**: Instead of pressing `j` 20 times, use `n` to jump to the next page

2. **Use search for specific cards**: Press `/` and search instead of browsing through thousands of cards

3. **Remember the pattern**: Type → Enter → See result. Once you get used to it, it becomes natural!

4. **Single letters only**: Commands are single letters (`j`, `k`, `n`, `p`, etc.). Don't type full words.

5. **Watch the prompt**: The yellow `Command>` prompt shows you're ready to type

## Still Confused?

Try this simple test:

1. Start the TUI: `./run_tui.sh`
2. Type `j` (don't press Enter yet)
3. Notice nothing happens
4. Now press Enter
5. See the cursor move!

That's it! Type command → Press Enter → See result.

Happy browsing! 🎯

