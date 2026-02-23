# Testing Jump to Card Feature (Elixir TUI)

## Changes Made

Added "Jump to Card" functionality that allows users to quickly navigate to a specific card by entering its card number.

### Modified Files

1. **lib/synergetics_tui/database.ex**
   - Added `get_card_by_number/2` function
   - Normalizes card number input (handles "1924", "C1924", "C01924", etc.)

2. **lib/synergetics_tui/tui.ex**
   - Added `:jump` mode to State struct
   - Added `jump_buffer` field to State
   - Added `render_jump/1` and `render_footer_jump/0` functions
   - Added 'g' key to input parser
   - Updated footer to show "g: Jump to card"

3. **lib/synergetics_tui/input_handler.ex**
   - Added `:jump` handler in list mode
   - Added `handle_input/2` for `:jump` mode
   - Handles character input, Enter, Esc, and back keys

## Testing Instructions

### Prerequisites

Make sure you have the dependencies installed:
```bash
cd synergetics_tui
mix deps.get
```

### Start the TUI

```bash
./run_tui.sh
```

Or from the project root:
```bash
cd synergetics_tui
../run_tui.sh
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

#### 7. Test Cancel with 'b' Key

**Steps:**
1. Press `g` from card list
2. Type some text (e.g., "456")
3. Press `b` key
4. **Expected:** Returns to card list with message "Returned to card list"

#### 8. Test Cancel with Empty Input

**Steps:**
1. Press `g` from card list
2. Don't type anything
3. Press `Enter`
4. **Expected:** Returns to card list with message "Returned to card list"

#### 9. Test Backspace

**Steps:**
1. Press `g` from card list
2. Type `12345`
3. Press Backspace twice
4. **Expected:** Buffer shows "123_"
5. Press `Enter`
6. **Expected:** Jumps to card 123 (if it exists)

#### 10. Test Footer Messages

**In Card List:**
- Footer should show: `↑/↓ or j/k: Navigate  Enter: View  g: Jump to card  /: Search`
- Second line: `n/p or ←/→: Next/Prev Page  q: Quit`

**In Jump Mode:**
- Footer should show: `Type card number  Enter: Jump to card  Esc or b: Back to card list`

### Keyboard Reference

| Mode | Key | Action |
|------|-----|--------|
| **Card List** | `g` | Enter jump mode |
| **Jump Input** | `Enter` | Jump to entered card number |
| **Jump Input** | `Esc` | Cancel and return to card list |
| **Jump Input** | `b` | Cancel and return to card list |
| **Jump Input** | Backspace | Delete last character |

## Expected Behavior Summary

### Jump Mode
- ✅ Pressing `g` from card list enters jump mode
- ✅ Shows "Jump to Card" header
- ✅ Accepts card numbers in multiple formats
- ✅ Footer shows "Type card number  Enter: Jump to card  Esc or b: Back to card list"

### Successful Jump
- ✅ Jumps to the specified card
- ✅ Shows card detail view
- ✅ Shows message "Jumped to card {number}"

### Failed Jump
- ✅ Returns to card list
- ✅ Shows message "Card not found: {number}"

### Cancel Jump
- ✅ Pressing `Esc` returns to card list
- ✅ Pressing `b` returns to card list
- ✅ Empty input returns to card list
- ✅ Shows message "Returned to card list"

### Card Number Formats
- ✅ `1924` works
- ✅ `01924` works
- ✅ `C1924` works
- ✅ `C01924` works
- ✅ Case-insensitive (c1924 also works)

