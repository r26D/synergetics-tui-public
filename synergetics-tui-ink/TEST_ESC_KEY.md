# Testing Esc Key to Return to Card List (Ink TUI)

## Changes Made

Added support for the Esc key to return to the card list from search and detail modes in the Ink/React-based TUI.

### Modified Files

1. **components/CardDetail.tsx**
   - Added `key.escape` to the back navigation condition
   - Updated footer: "Esc or b or ←: Back to list"

2. **components/SearchInput.tsx**
   - Added explicit `useInput` hook to handle Esc key
   - Updated footer: "Esc: Back to card list" (changed from "Cancel")

3. **index.tsx**
   - Updated `handleSearchCancel` to show "Returned to card list" message

## Testing Instructions

### Prerequisites

Make sure you have the dependencies installed:
```bash
cd synergetics-tui-ink
npm install
```

### Start the TUI

```bash
npm start
```

Or use the shell script from the project root:
```bash
./run_tui_ink.sh
```

### Test Cases

#### 1. Test Search Mode - Esc Key

**Steps:**
1. Press `/` to enter search mode
2. You should see "Search Cards" header
3. Press `Esc` key
4. **Expected:** Returns to card list with yellow message "Returned to card list"

**Steps (with query):**
1. Press `/` to enter search mode
2. Type some text (e.g., "vector")
3. Press `Esc` key
4. **Expected:** Returns to card list without searching, shows "Returned to card list"

#### 2. Test Search Mode - Enter Key

**Steps:**
1. Press `/` to enter search mode
2. Type a search query (e.g., "tetra")
3. Press `Enter`
4. **Expected:** Shows search results with message "Search results for: tetra"

#### 2b. Test Search Results - Esc Key to Clear Search

**Steps:**
1. Press `/` to enter search mode
2. Type a search query (e.g., "tetra")
3. Press `Enter` to see search results
4. Press `Esc` key while viewing search results
5. **Expected:** Returns to full card list with message "Returned to full card list"
6. **Expected:** Footer changes from "Esc: Clear search | ..." to "j/k or ↑/↓: Navigate | ..."

#### 3. Test Detail Mode - Esc Key

**Steps:**
1. Navigate to a card using arrow keys or j/k
2. Press `Enter` to view card details
3. Press `Esc` key
4. **Expected:** Returns to card list

#### 4. Test Detail Mode - Other Keys

**Steps:**
1. View a card (press `Enter` on any card)
2. Press `b` key
3. **Expected:** Returns to card list

**Steps:**
1. View a card (press `Enter` on any card)
2. Press left arrow `←`
3. **Expected:** Returns to card list

#### 5. Test Footer Messages

**In Card List (Full List):**
- Footer should show: `j/k or ↑/↓: Navigate | Enter: View | /: Search | n/p or ←/→: Next/Prev Page | r: Refresh | q: Quit`

**In Card List (Search Results):**
- Footer should show: `Esc: Clear search | j/k or ↑/↓: Navigate | Enter: View | /: New search | n/p or ←/→: Next/Prev Page | r: Refresh | q: Quit`

**In Search Mode:**
- Footer should show: `Enter: Search | Esc: Back to card list`

**In Detail Mode:**
- Footer should show: `Esc or b or ←: Back to list | q: Quit`

### Keyboard Reference

| Mode | Key | Action |
|------|-----|--------|
| **Card List (Full)** | `/` | Enter search mode |
| | `Enter` | View selected card |
| | `j` or `↓` | Navigate down |
| | `k` or `↑` | Navigate up |
| | `n` or `→` | Next page |
| | `p` or `←` | Previous page |
| | `r` | Refresh |
| | `q` | Quit |
| **Card List (Search Results)** | `Esc` | Clear search, return to full list |
| | `/` | New search |
| | `Enter` | View selected card |
| | `j` or `↓` | Navigate down |
| | `k` or `↑` | Navigate up |
| | `n` or `→` | Next page |
| | `p` or `←` | Previous page |
| | `r` | Refresh |
| | `q` | Quit |
| **Search Input** | `Esc` | Back to card list |
| | `Enter` | Execute search |
| **Detail** | `Esc` | Back to card list |
| | `b` | Back to card list |
| | `←` | Back to card list |
| | `q` | Quit |

## Expected Behavior Summary

### Search Input Mode
- ✅ Pressing `Esc` returns to card list
- ✅ Shows "Returned to card list" message
- ✅ Does not execute search
- ✅ Footer clearly shows "Esc: Back to card list"

### Search Results Mode (Card List with Active Search)
- ✅ Pressing `Esc` clears search and returns to full card list
- ✅ Shows "Returned to full card list" message
- ✅ Footer shows "Esc: Clear search | ..."
- ✅ Can start new search with `/`

### Detail Mode
- ✅ Pressing `Esc` returns to card list
- ✅ Pressing `b` returns to card list
- ✅ Pressing `←` returns to card list
- ✅ Footer shows all three options

### Messages
- ✅ Search cancel (from input) shows: "Returned to card list"
- ✅ Search clear (from results) shows: "Returned to full card list"
- ✅ Search submit shows: "Search results for: {query}"
- ✅ Refresh shows: "Refreshed - {count} cards loaded"

## Troubleshooting

### Esc key not working

If Esc key doesn't work:
1. Check your terminal emulator settings
2. Try running in a different terminal (iTerm2, Terminal.app, etc.)
3. Verify that Ink is properly installed: `npm list ink`

### Terminal not responding

If the terminal becomes unresponsive:
1. Press `Ctrl+C` to force quit
2. Restart the TUI
3. Check that the database file exists at `../data/synergetics_dictionary.db`

## Comparison with Elixir TUI

Both TUI implementations now have identical Esc key behavior:

| Feature | Elixir TUI | Ink TUI |
|---------|-----------|---------|
| Esc in search | ✅ | ✅ |
| Esc in detail | ✅ | ✅ |
| Message on cancel | ✅ | ✅ |
| Footer updates | ✅ | ✅ |

## Benefits

1. **Consistency**: Both TUI implementations work the same way
2. **Intuitive**: Esc is the standard "go back" key
3. **Clear**: Footer messages explain all options
4. **Flexible**: Multiple ways to navigate (Esc, b, arrow keys)

