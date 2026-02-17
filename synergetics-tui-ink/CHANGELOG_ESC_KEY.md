# Changelog: Esc Key Support for Returning to Card List

**Date:** 2026-02-14

## Summary

Added Esc key support to improve navigation in the Synergetics Dictionary TUI (Ink/React version). Users can now press Esc to return to the card list from search mode, or to go back from detail view.

## Changes

### 1. Enhanced CardDetail Component (`components/CardDetail.tsx`)

**Modified:** `useInput` hook (line 8)

- Previously: Only `b` or left arrow returned to list
- Now: Added `key.escape` to the condition
- Code change:
  ```typescript
  // Before
  } else if (input === 'b' || key.leftArrow) {
  
  // After
  } else if (input === 'b' || key.leftArrow || key.escape) {
  ```

**Updated Footer Message** (line 71):
- Before: `"b or ←: Back | q: Quit"`
- After: `"Esc or b or ←: Back to list | q: Quit"`

### 2. Enhanced SearchInput Component (`components/SearchInput.tsx`)

**Added:** Explicit Esc key handler using `useInput` hook (lines 8-12)

```typescript
// Handle Esc key explicitly to ensure it returns to card list
useInput((input, key) => {
  if (key.escape) {
    onCancel();
  }
});
```

**Updated Footer Message** (line 39):
- Before: `"Enter: Search | Esc: Cancel"`
- After: `"Enter: Search | Esc: Back to card list"`

### 3. Enhanced CardList Component (`components/CardList.tsx`)

**Added:** Esc key handler to clear search results (line 25)

```typescript
} else if (key.escape && searchQuery) {
  onClearSearch();
```

**Updated Footer Message** (lines 77-79):
- Now conditionally shows different messages based on whether viewing search results
- When viewing search results: `"Esc: Clear search | ..."`
- When viewing full list: `"j/k or ↑/↓: Navigate | ..."`

### 4. Enhanced Main App (`index.tsx`)

**Modified:** `handleSearchCancel` function (lines 62-65)

- Previously: Only changed mode to list
- Now: Also sets a confirmation message
- Code change:
  ```typescript
  const handleSearchCancel = () => {
    setMode('list');
    setMessage('Returned to card list');  // Added
  };
  ```

**Added:** `handleClearSearch` function (lines 93-97)

```typescript
const handleClearSearch = () => {
  setSearchQuery('');
  loadCards(null, 0);
  setMessage('Returned to full card list');
};
```

**Modified:** CardList props (lines 117-118)
- Added `onClearSearch={handleClearSearch}`
- Added `searchQuery={searchQuery}`

## User Experience Improvements

1. **More Intuitive**: Esc is a universal "go back" or "cancel" key in most applications
2. **Dual Options**: Users can choose between Esc (standard) or letter keys (b)
3. **Consistent Behavior**: Esc works across search input, search results, and detail modes
4. **Clear Feedback**:
   - Footer messages clearly indicate Esc key option
   - Search cancel shows "Returned to card list" message
   - Search clear shows "Returned to full card list" message
   - Footer changes based on context (search results vs full list)
5. **Better Messaging**: Changed "Cancel" to "Back to card list" for clarity
6. **Search Results Navigation**: Can now exit search results back to full card list with Esc

## Comparison with Elixir TUI

This implementation matches the functionality added to the Elixir-based TUI (`synergetics_tui`):

| Feature | Elixir TUI | Ink TUI |
|---------|-----------|---------|
| Esc in search mode | ✅ Returns to card list | ✅ Returns to card list |
| Esc in detail mode | ✅ Returns to card list | ✅ Returns to card list |
| Confirmation message | ✅ "Returned to card list" | ✅ "Returned to card list" |
| Footer updates | ✅ Shows "Esc or b" | ✅ Shows "Esc or b" |

## Backward Compatibility

All existing keybindings remain functional:
- `b` still works to go back in detail mode
- Left arrow still works to go back in detail mode
- No breaking changes to existing functionality

## Testing

### Manual Testing Instructions

1. Start the TUI:
   ```bash
   cd synergetics-tui-ink
   npm start
   ```

2. Test search mode:
   - Press `/` to enter search mode
   - Press `Esc` - should return to card list with message "Returned to card list"
   - Press `/` again and type a query, then press `Enter` - should show search results

3. Test detail mode:
   - Navigate to a card and press `Enter` to view details
   - Press `Esc` - should return to card list
   - View another card and press `b` - should also return to card list
   - View another card and press left arrow - should also return to card list

### Expected Behavior

- **Search mode**: Pressing `Esc` returns to the full card list and shows "Returned to card list" message
- **Detail mode**: Pressing `Esc`, `b`, or left arrow returns to the card list
- All modes show clear instructions in the footer about using Esc key

## Technical Notes

### Ink's useInput Hook

The `useInput` hook from Ink provides a `key` object with boolean properties for special keys:
- `key.escape` - Esc key
- `key.return` - Enter key
- `key.upArrow`, `key.downArrow`, `key.leftArrow`, `key.rightArrow` - Arrow keys

### TextInput Component

The `ink-text-input` component (v6.0.0) handles Esc key internally, but we added an explicit `useInput` handler in the SearchInput component to ensure consistent behavior and proper message display.

## Related

- Addresses TODO: "TUI: Add action to return to card list when done searching"
- Matches functionality in Elixir TUI (`synergetics_tui`)
- Enhances overall TUI navigation experience across both implementations

