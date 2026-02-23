# Changelog: Jump to Card Feature (Elixir TUI)

**Date:** 2026-02-14  
**Feature:** Add jump-to-card functionality with 'g' key

## Summary

Added the ability to jump directly to a specific card by entering its card number. This feature provides quick navigation to known cards without scrolling through the list.

## Changes

### Database Module (`lib/synergetics_tui/database.ex`)

#### Added `get_card_by_number/2` function

```elixir
@doc """
Gets a single card by card number.
Accepts various formats: 1924, C1924, C01924, 01924
Returns the card map or nil if not found.
"""
def get_card_by_number(conn, card_number)
```

**Features:**
- Normalizes card number input by removing "C" prefix and leading zeros
- Converts to integer for database lookup
- Returns full card details with cross_references and citations
- Returns `nil` if card not found

**Supported Formats:**
- `1924` - Plain number
- `01924` - With leading zeros
- `C1924` - With C prefix
- `C01924` - Full card ID format
- `c1924` - Case-insensitive

### TUI Module (`lib/synergetics_tui/tui.ex`)

#### Updated State struct

Added `:jump` mode and `jump_buffer` field:

```elixir
defstruct [
  :conn,
  :mode,           # :list, :detail, :edit, :search, :jump
  :cards,
  :current_card,
  :selected_index,
  :offset,
  :total_count,
  :search_query,
  :jump_buffer,    # NEW: Buffer for jump input
  :edit_field,
  :edit_buffer,
  :message
]
```

#### Added render functions

**`render/1` for `:jump` mode:**
- Calls `render_jump/1` and `render_footer_jump/0`

**`render_jump/1`:**
- Shows "Jump to Card" header
- Displays current input buffer with cursor
- Shows helpful hint about supported formats

**`render_footer_jump/0`:**
- Shows available commands in jump mode
- Explains keyboard shortcuts

#### Updated footer for list mode

Changed from:
```
↑/↓ or j/k: Navigate  Enter: View  /: Search  n/p or ←/→: Next/Prev Page  q: Quit
```

To:
```
↑/↓ or j/k: Navigate  Enter: View  g: Jump to card  /: Search
n/p or ←/→: Next/Prev Page  q: Quit
```

#### Added 'g' key to input parser

In `read_char_input/1`, added:
```elixir
"g" -> :jump
```

### Input Handler Module (`lib/synergetics_tui/input_handler.ex`)

#### Updated list mode handler

Added `:jump` case to enter jump mode:
```elixir
:jump ->
  %{state | mode: :jump, jump_buffer: ""}
```

#### Added jump mode handler

**`handle_input(%State{mode: :jump}, input)`:**

Handles the following inputs:

1. **Character input** (`{:char, char}`)
   - Appends characters to jump buffer
   - Handles backspace/delete to remove characters

2. **Enter key** (`:enter`)
   - If buffer is empty: returns to card list
   - If buffer has value: attempts to find card
   - On success: shows card detail with success message
   - On failure: returns to list with error message

3. **Escape key** (`:escape`)
   - Returns to card list with confirmation message

4. **Back key** (`:back`)
   - Returns to card list with confirmation message

## User Experience

### Entering Jump Mode

1. From card list, press `g`
2. Screen shows "Jump to Card" header
3. Input buffer is empty and ready for typing

### Entering Card Number

1. Type card number in any supported format
2. Characters appear immediately in the buffer
3. Use Backspace to correct mistakes

### Jumping to Card

1. Press Enter to jump
2. If card exists: shows card detail view with "Jumped to card {number}" message
3. If card doesn't exist: returns to list with "Card not found: {number}" message

### Canceling Jump

1. Press Esc or 'b' to cancel
2. Returns to card list with "Returned to card list" message

## Benefits

1. **Fast Navigation**: Jump directly to known cards without scrolling
2. **Flexible Input**: Multiple card number formats supported
3. **Intuitive**: 'g' key is common for "go to" in many tools (vim, less, etc.)
4. **Clear Feedback**: Success and error messages
5. **Consistent**: Same UX pattern as search feature
6. **Forgiving**: Accepts various input formats

## Use Cases

- **Quick Reference**: Jump to a specific card you know by number
- **Cross-Reference**: When reading a card that mentions another card number
- **Testing**: Quickly navigate to specific cards for testing
- **Documentation**: Jump to cards mentioned in documentation

## Comparison with Ink TUI

Both TUI implementations now have identical jump-to-card functionality:

| Feature | Elixir TUI | Ink TUI |
|---------|-----------|---------|
| Jump key | `g` | `g` |
| Cancel keys | Esc, b | Esc |
| Supported formats | 1924, C1924, C01924, 01924 | 1924, C1924, C01924, 01924 |
| Success message | ✅ | ✅ |
| Error message | ✅ | ✅ |
| Backspace support | ✅ | ✅ |

## Testing

See `TEST_JUMP_TO_CARD.md` for comprehensive testing instructions.

## Related

- **TODO Item:** "TUI: Add action to jump to specific card number from card list" ✅ Complete
- **Ink TUI Implementation:** `synergetics-tui-ink/TEST_JUMP_TO_CARD.md`
- **Repository:** `/Users/belmendo/Projects/elib-synergetics-dictionary`

