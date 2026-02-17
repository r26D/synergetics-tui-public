# Testing Jump to Card Feature (Ink TUI)

## Changes Made

Added "Jump to Card" functionality that allows users to quickly navigate to a specific card by entering its card number.

### Modified Files

1. **components/JumpToCardInput.tsx** (NEW)
   - New component for card number input
   - Supports Esc key to cancel
   - Accepts various card number formats

2. **database.js**
   - Added `getCardByNumber` function
   - Normalizes card number input (handles "1924", "C1924", "C01924", etc.)

3. **index.tsx**
   - Added 'jump' mode
   - Added jump handlers: `handleJump`, `handleJumpSubmit`, `handleJumpCancel`
   - Imported `getCardByNumber` and `JumpToCardInput`
   - Added jump mode rendering

4. **components/CardList.tsx**
   - Added `onJump` prop
   - Added 'g' key handler
   - Updated footer to show "g: Jump to card"

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

#### 1. Test Jump with Plain Number

**Steps:**
1. From the card list, press `g`
2. You should see "Jump to Card" header
3. Type `1924` (just the number)
4. Press `Enter`
5. **Expected:** Jumps to card C01924 and shows "Jumped to card 1924"

#### 2. Test Jump with C Prefix

**Steps:**
1. Press `g` from card list
2. Type `C1924`
3. Press `Enter`
4. **Expected:** Jumps to card C01924 and shows "Jumped to card 1924"

#### 3. Test Jump with Full Card ID

**Steps:**
1. Press `g` from card list
2. Type `C01924` (with leading zeros)
3. Press `Enter`
4. **Expected:** Jumps to card C01924 and shows "Jumped to card 1924"

#### 4. Test Jump with Leading Zeros

**Steps:**
1. Press `g` from card list
2. Type `01924` (leading zeros, no C)
3. Press `Enter`
4. **Expected:** Jumps to card C01924 and shows "Jumped to card 1924"

#### 5. Test Jump to Non-Existent Card

**Steps:**
1. Press `g` from card list
2. Type `99999` (a card number that doesn't exist)
3. Press `Enter`
4. **Expected:** Returns to card list with message "Card not found: 99999"

#### 6. Test Cancel with Esc Key

**Steps:**
1. Press `g` from card list
2. Type some text (e.g., "123")
3. Press `Esc` key
4. **Expected:** Returns to card list with message "Returned to card list"

#### 7. Test Cancel with Empty Input

**Steps:**
1. Press `g` from card list
2. Don't type anything
3. Press `Enter`
4. **Expected:** Returns to card list (same as cancel)

#### 8. Test Jump from Search Results

**Steps:**
1. Press `/` to search
2. Type "tetra" and press `Enter` to see search results
3. Press `g` to jump
4. Type `11` (card C00011)
5. Press `Enter`
6. **Expected:** Jumps to card C00011 and shows "Jumped to card 11"

#### 9. Test Footer Messages

**In Card List (Full List):**
- Footer should show: `j/k or ↑/↓: Navigate | Enter: View | g: Jump to card | /: Search | n/p or ←/→: Next/Prev Page | r: Refresh | q: Quit`

**In Card List (Search Results):**
- Footer should show: `Esc: Clear search | j/k or ↑/↓: Navigate | Enter: View | g: Jump to card | /: New search | n/p or ←/→: Next/Prev Page | r: Refresh | q: Quit`

**In Jump Mode:**
- Footer should show: `Enter: Jump to card | Esc: Back to card list`

### Keyboard Reference

| Mode | Key | Action |
|------|-----|--------|
| **Card List** | `g` | Enter jump mode |
| **Jump Input** | `Enter` | Jump to entered card number |
| **Jump Input** | `Esc` | Cancel and return to card list |

## Expected Behavior Summary

### Jump Mode
- ✅ Pressing `g` from card list enters jump mode
- ✅ Shows "Jump to Card" header
- ✅ Accepts card numbers in multiple formats
- ✅ Footer shows "Enter: Jump to card | Esc: Back to card list"

### Successful Jump
- ✅ Jumps to the specified card
- ✅ Shows card detail view
- ✅ Shows message "Jumped to card {number}"

### Failed Jump
- ✅ Returns to card list
- ✅ Shows message "Card not found: {number}"

### Cancel Jump
- ✅ Pressing `Esc` returns to card list
- ✅ Empty input returns to card list
- ✅ Shows message "Returned to card list"

### Card Number Formats
- ✅ `1924` works
- ✅ `01924` works
- ✅ `C1924` works
- ✅ `C01924` works
- ✅ Case-insensitive (c1924 also works)

## Troubleshooting

### Jump doesn't work

If jump doesn't work:
1. Make sure you're in card list mode (not detail or search mode)
2. Press `g` (lowercase)
3. Verify the card number exists in the database

### Card not found

If you get "Card not found" for a card you know exists:
1. Check the exact card number in the database
2. Try different formats (with/without C prefix, with/without leading zeros)
3. Make sure you're entering just the number, not the full "C00011" format with extra characters

### Terminal not responding

If the terminal becomes unresponsive:
1. Press `Ctrl+C` to force quit
2. Restart the TUI
3. Check that the database file exists at `../data/synergetics_dictionary.db`

## Benefits

1. **Fast Navigation**: Jump directly to known cards without scrolling
2. **Flexible Input**: Multiple card number formats supported
3. **Intuitive**: 'g' key is common for "go to" in many tools (vim, less, etc.)
4. **Clear Feedback**: Success and error messages
5. **Consistent**: Same UX pattern as search feature

## Use Cases

- **Quick Reference**: Jump to a specific card you know by number
- **Cross-Reference**: When reading a card that mentions another card number
- **Testing**: Quickly navigate to specific cards for testing
- **Documentation**: Jump to cards mentioned in documentation

