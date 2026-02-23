# Arrow Keys Are Instant! ⚡

## The Good News

**Arrow keys work instantly - no need to press Enter!**

When you press an arrow key, the terminal automatically sends it with a newline character, so the TUI responds immediately.

## How It Works

### Technical Explanation

Arrow keys send ANSI escape sequences that include a newline:
- Up arrow: `ESC [ A \n` (bytes: 27, 91, 65, 10)
- Down arrow: `ESC [ B \n` (bytes: 27, 91, 66, 10)
- Right arrow: `ESC [ C \n` (bytes: 27, 91, 67, 10)
- Left arrow: `ESC [ D \n` (bytes: 27, 91, 68, 10)

The `\n` (newline) at the end means `IO.gets/1` returns immediately when you press an arrow key.

### Letter Commands

Letter commands like `j`, `k`, `n`, `p` do NOT include a newline automatically, so you must press Enter after typing them.

## User Experience

### Instant Commands (No Enter Needed)
- `↑` - Move up
- `↓` - Move down
- `→` - View/select
- `←` - Go back

### Commands That Need Enter
- `j` + Enter - Move down
- `k` + Enter - Move up
- `n` + Enter - Next page
- `p` + Enter - Previous page
- `/` + Enter - Search
- `e` + Enter - Edit
- `s` + Enter - Save
- `b` + Enter - Back
- `q` + Enter - Quit

## Recommendation

**Use arrow keys for navigation!**

They provide a much better user experience:
- ✅ Instant response
- ✅ No need to remember to press Enter
- ✅ More intuitive for most users
- ✅ Feels like a "real" TUI application

Letter commands are still available for:
- Users who prefer vim-style navigation
- Terminals that don't support arrow keys well
- Pagination (n/p) and other non-navigation commands

## Why This Matters

This makes the TUI feel much more responsive and professional, even though it's using simple line-based input (`IO.gets/1`) instead of a complex terminal library.

### Before (All Commands Needed Enter)
```
User: [presses ↓]
TUI: (waiting...)
User: [presses Enter]
TUI: (moves down)
```

### After (Arrow Keys Instant)
```
User: [presses ↓]
TUI: (moves down immediately!)
```

## Implementation

The key insight is that arrow keys already include the newline character that `IO.gets/1` waits for, so they work instantly without any special handling.

No code changes were needed - just documentation updates to clarify this behavior!

## Future Enhancements

While arrow keys are instant, we could make ALL commands instant by:

1. **Using a terminal library** like Ratatouille
   - Character-by-character input
   - Full terminal control
   - Mouse support
   - More complex to set up

2. **Using raw terminal mode** with `:io.setopts`
   - Can read single characters
   - More control over input
   - Platform-specific behavior

3. **Current approach (line-based with arrow keys)**
   - Simple and reliable
   - Arrow keys are instant
   - Letter commands need Enter
   - Good enough for most use cases ✅

## Conclusion

The TUI now provides a great user experience with instant arrow key navigation, while maintaining simplicity and reliability with line-based input for other commands.

**Just use the arrow keys and enjoy!** ⚡

