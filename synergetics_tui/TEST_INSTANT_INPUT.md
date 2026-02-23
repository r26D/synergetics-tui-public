# Testing Instant Input

## How to Test

Run the TUI:

```bash
cd synergetics_tui
mix tui
```

Or from the project root:

```bash
./run_tui.sh
```

## What to Test

### 1. Arrow Keys (Should Work Instantly)

**Test up/down navigation:**
- Press `↓` (down arrow) - cursor should move down immediately
- Press `↑` (up arrow) - cursor should move up immediately
- No need to press Enter!

**Test left/right:**
- Press `→` (right arrow) - should view card details immediately
- Press `←` (left arrow) - should go back to list immediately

### 2. Letter Commands (Should Work Instantly)

**Test vim-style navigation:**
- Press `j` - cursor should move down immediately
- Press `k` - cursor should move up immediately

**Test other commands:**
- Press `n` - should go to next page immediately
- Press `p` - should go to previous page immediately
- Press `q` - should quit immediately

### 3. Search Mode (Should Type Instantly)

- Press `/` - should enter search mode immediately
- Type letters - they should appear as you type
- Press Backspace - should delete characters
- Press `↑`/`↓` - should navigate results
- Press `←` or `b` - should go back to list

### 4. View and Edit

- Navigate to a card and press `→` or Enter
- Press `e` - should enter edit mode
- Press `1`, `2`, or `3` - should select a field
- Type letters - they should appear as you type
- Press Backspace - should delete characters
- Press `s` - should save
- Press `c` or `b` - should cancel/go back

## Expected Behavior

### ✅ What Should Happen

- **All keys work instantly** - no need to press Enter
- **Arrow keys work smoothly** - no visible escape sequences like `^[[A`
- **Typing appears in real-time** - in search and edit modes
- **Backspace works** - deletes characters
- **Navigation is responsive** - cursor moves immediately

### ❌ What Should NOT Happen

- You should NOT see escape sequences like `^[[A` or `^[[B`
- You should NOT need to press Enter after commands
- Keys should NOT be echoed to the screen (except in search/edit modes)
- The terminal should NOT be messed up after quitting

## Troubleshooting

### If Arrow Keys Don't Work

The TUI uses `stty` to set raw mode. If arrow keys aren't working:

1. **Check if stty is available:**
   ```bash
   which stty
   ```

2. **Manually test raw mode:**
   ```bash
   stty -icanon min 1 time 0
   # Try typing - characters should appear immediately
   stty icanon echo
   # Restore normal mode
   ```

3. **Check terminal type:**
   ```bash
   echo $TERM
   ```
   Should be something like `xterm-256color` or `screen-256color`

### If Terminal is Messed Up After Quitting

The TUI should restore terminal settings automatically. If it doesn't:

```bash
stty sane
reset
```

### If You See Escape Sequences

If you see `^[[A` when pressing arrow keys, it means raw mode isn't working. Try:

1. Use a different terminal (iTerm2, Terminal.app, etc.)
2. Check if your terminal supports raw mode
3. Fall back to letter commands (j/k/n/p) which should still work

## Technical Details

### How It Works

1. **Save original terminal settings** with `:io.getopts(:standard_io)`
2. **Enable raw mode** with `stty -icanon min 1 time 0`
3. **Disable echo** with `:io.setopts(:standard_io, [echo: false])`
4. **Read characters one at a time** with `:io.get_chars(:standard_io, "", 1)`
5. **Handle escape sequences** for arrow keys (ESC [ A/B/C/D)
6. **Restore terminal** on exit with `stty icanon echo`

### Why This Approach

- Uses standard Unix `stty` command for raw mode
- Works on macOS, Linux, and most Unix systems
- Properly restores terminal state on exit
- No external dependencies needed

## Success Criteria

The instant input is working correctly if:

- ✅ Arrow keys move cursor immediately
- ✅ Letter commands work immediately
- ✅ No visible escape sequences
- ✅ Search typing appears in real-time
- ✅ Backspace works
- ✅ Terminal is normal after quitting

## Report Issues

If arrow keys or instant input aren't working, please note:

1. Your operating system (macOS, Linux, etc.)
2. Your terminal emulator (Terminal.app, iTerm2, etc.)
3. Output of `echo $TERM`
4. Whether letter commands (j/k) work
5. What you see when you press arrow keys

This will help debug any issues!

