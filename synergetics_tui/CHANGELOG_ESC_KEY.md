# Changelog: Esc Key Support for Returning to Card List

**Date:** 2026-02-14

## Summary

Added Esc key support to improve navigation in the Synergetics Dictionary TUI. Users can now press Esc to return to the card list from search mode, or to go back from detail/edit modes.

## Changes

### 1. Enhanced Escape Key Detection (`lib/synergetics_tui/tui.ex`)

**Modified:** `read_char_input/1` function (lines 325-341)

- Previously: Escape sequences (like arrow keys) were detected, but standalone Esc key was not handled
- Now: Detects standalone Esc key presses and returns `:escape` atom
- Implementation: Peeks at the next character after `\e` to distinguish between:
  - Escape sequences (e.g., `\e[A` for up arrow)
  - Standalone Esc key press (just `\e` with no following character)

### 2. Updated Footer Messages (`lib/synergetics_tui/tui.ex`)

**Search Mode Footer** (line 293):
- Before: `"Type to search  ↑/↓: Navigate  Enter: View  b: Back"`
- After: `"Type to search  ↑/↓: Navigate  Enter: View  Esc or b: Back to card list  q: Quit"`

**Detail Mode Footer** (line 239):
- Before: `"e: Edit  b: Back to list  q: Quit"`
- After: `"e: Edit  Esc or b: Back to list  q: Quit"`

**Edit Mode Footer** (line 266):
- Before: `"1-3: Select field  s: Save  c: Cancel  b: Back"`
- After: `"1-3: Select field  s: Save  Esc or c: Cancel  b: Back"`

### 3. Added Esc Key Handlers (`lib/synergetics_tui/input_handler.ex`)

**Search Mode** (lines 152-154):
```elixir
:escape ->
  cards = Database.list_cards(state.conn, limit: @page_size, offset: state.offset)
  %{state | mode: :list, search_query: "", cards: cards, selected_index: 0, message: "Returned to card list"}
```
- Returns to card list
- Clears search query
- Reloads full card list
- Shows confirmation message

**Detail Mode** (lines 52-53):
```elixir
:escape ->
  %{state | mode: :list, current_card: nil}
```
- Returns to card list
- Clears current card

**Edit Mode** (lines 100-101):
```elixir
:escape ->
  %{state | mode: :detail, edit_field: nil, edit_buffer: ""}
```
- Cancels edit
- Returns to detail view
- Clears edit buffer

## User Experience Improvements

1. **More Intuitive**: Esc is a universal "go back" or "cancel" key in most applications
2. **Dual Options**: Users can choose between Esc (standard) or letter keys (b/c)
3. **Consistent Behavior**: Esc works across all modes (search, detail, edit)
4. **Clear Feedback**: Footer messages clearly indicate both options
5. **Confirmation Message**: Search mode shows "Returned to card list" message

## Backward Compatibility

All existing keybindings remain functional:
- `b` still works to go back in all modes
- `c` still works to cancel in edit mode
- No breaking changes to existing functionality

## Testing

See `TEST_ESC_KEY.md` for detailed testing instructions.

## Related

- Addresses TODO: "TUI: Add action to return to card list when done searching"
- Enhances overall TUI navigation experience

