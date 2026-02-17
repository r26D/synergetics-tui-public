# Changelog: Jump to Card Feature

**Date:** 2026-02-14

## Summary

Added "Jump to Card" functionality to the Synergetics Dictionary TUI (Ink/React version). Users can now press 'g' from the card list to jump directly to a specific card by entering its card number, without needing to scroll through pages or search.

## Changes

### 1. New Component: JumpToCardInput (`components/JumpToCardInput.tsx`)

**Created:** New component for card number input

**Features:**
- Text input for entering card number
- Accepts numbers with or without 'C' prefix (e.g., "1924" or "C01924")
- Esc key support to cancel and return to card list
- Enter key to jump to the specified card
- Clear instructions in the footer

**Code Structure:**
```typescript
export default function JumpToCardInput({ onSubmit, onCancel }) {
  const [cardNumber, setCardNumber] = useState('');
  
  useInput((input, key) => {
    if (key.escape) {
      onCancel();
    }
  });
  
  const handleSubmit = () => {
    if (cardNumber.trim()) {
      onSubmit(cardNumber.trim());
    } else {
      onCancel();
    }
  };
  // ... render logic
}
```

### 2. Enhanced Database Module (`database.js`)

**Added:** `getCardByNumber` function (lines 52-60)

```javascript
export function getCardByNumber(cardNumber) {
  const db = openDatabase();
  // Normalize card number (remove 'C' prefix and leading zeros)
  const numericPart = String(cardNumber).replace(/^C0*/i, '');
  const paddedNumber = parseInt(numericPart, 10);
  
  return db.prepare('SELECT * FROM cards WHERE card_number = ?').get(paddedNumber);
}
```

**Features:**
- Accepts card numbers in multiple formats: "1924", "01924", "C1924", "C01924"
- Normalizes input by removing 'C' prefix and leading zeros
- Returns full card data or null if not found

### 3. Enhanced Main App (`index.tsx`)

**Modified:** Mode state to include 'jump' (line 10)
```typescript
const [mode, setMode] = useState('list'); // 'list', 'detail', 'search', 'jump'
```

**Added:** Import for new component and database function (lines 4, 8)
```typescript
import { countCards, listCards, getCard, getCardByNumber, closeDatabase } from './database.js';
import JumpToCardInput from './components/JumpToCardInput.tsx';
```

**Added:** Jump handlers (lines 100-120)

```typescript
const handleJump = () => {
  setMode('jump');
};

const handleJumpSubmit = (cardNumber) => {
  const card = getCardByNumber(cardNumber);
  if (card) {
    const fullCard = getCard(card.id);
    setCurrentCard(fullCard);
    setMode('detail');
    setMessage(`Jumped to card ${card.card_number}`);
  } else {
    setMode('list');
    setMessage(`Card not found: ${cardNumber}`);
  }
};

const handleJumpCancel = () => {
  setMode('list');
  setMessage('Returned to card list');
};
```

**Added:** Jump mode rendering (lines 174-180)
```typescript
{mode === 'jump' && (
  <JumpToCardInput
    onSubmit={handleJumpSubmit}
    onCancel={handleJumpCancel}
  />
)}
```

**Modified:** CardList props to include `onJump` (line 139)

### 4. Enhanced CardList Component (`components/CardList.tsx`)

**Added:** `onJump` prop (line 9)

**Added:** 'g' key handler (lines 28-29)
```typescript
} else if (input === 'g') {
  onJump();
```

**Updated Footer Messages** (lines 80-82):
- When viewing full list: Added "g: Jump to card"
- When viewing search results: Added "g: Jump to card"

## User Experience

### How to Use

1. **From Card List**: Press `g` to enter jump mode
2. **Enter Card Number**: Type the card number (e.g., "1924" or "C01924")
3. **Jump**: Press `Enter` to jump to the card
4. **Cancel**: Press `Esc` to return to card list without jumping

### Supported Card Number Formats

All of these formats work for card C01924:
- `1924` (just the number)
- `01924` (with leading zeros)
- `C1924` (with C prefix)
- `C01924` (full card ID)

### Feedback Messages

- **Success**: "Jumped to card 1924"
- **Not Found**: "Card not found: 99999"
- **Cancel**: "Returned to card list"

## Benefits

1. **Fast Navigation**: Jump directly to known cards without scrolling
2. **Flexible Input**: Accepts multiple card number formats
3. **Intuitive**: Uses 'g' key (common "go to" keybinding in many tools)
4. **Clear Feedback**: Shows success or error messages
5. **Consistent UX**: Follows same pattern as search feature (Esc to cancel, Enter to submit)

## Keyboard Reference

| Mode | Key | Action |
|------|-----|--------|
| **Card List** | `g` | Enter jump mode |
| **Jump Input** | `Enter` | Jump to entered card number |
| **Jump Input** | `Esc` | Cancel and return to card list |

## Technical Notes

### Card Number Normalization

The `getCardByNumber` function normalizes card numbers by:
1. Converting to string
2. Removing 'C' prefix (case-insensitive)
3. Removing leading zeros
4. Converting to integer for database lookup

This ensures that all common formats work correctly.

### Error Handling

- If card is not found, returns to list mode with error message
- Empty input cancels the jump (same as Esc)
- Invalid numbers are handled gracefully by the database query

## Related

- Addresses TODO: "TUI: Add action to jump to specific card number from card list"
- Complements the search feature (/) for different use cases
- Similar to "go to line" features in text editors

