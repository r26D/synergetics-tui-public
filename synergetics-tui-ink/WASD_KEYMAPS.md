# WASD Keymaps Implementation

## Overview

Added gaming-style WASD keymaps to the Synergetics Dictionary TUI as alternatives to existing navigation keys.

## Key Mappings

### Gaming-Style (WASD)
- **W** = Up (navigate up in lists)
- **A** = Left (go back, previous page)
- **S** = Down (navigate down in lists)
- **D** = Right (next page)

### Existing Keys (Still Supported)
- **Arrow keys** (↑/↓/←/→)
- **b** (back in detail view)
- **Esc** (back/cancel)

## Changes Made

### CardList Component (`components/CardList.tsx`)

**Navigation (Up/Down):**
- Added `w` for up navigation (alongside `↑`)
- Added `s` for down navigation (alongside `↓`)

**Pagination (Left/Right):**
- Added `a` for previous page (alongside `←`)
- Added `d` for next page (alongside `→`)

**Removed Keys:**
- Removed `j/k` (Vim-style) navigation
- Removed `p/n` pagination keys

**Updated Help Text:**
- Before: `j/k or ↑/↓: Navigate | ... | n/p or ←/→: Next/Prev Page`
- After: `w/s/↑/↓: Navigate | ... | a/d/←/→: Prev/Next Page`

### CardDetail Component (`components/CardDetail.tsx`)

**Back Navigation:**
- Added `a` for back (alongside `b`, `←`, and `Esc`)

**Updated Help Text:**
- Before: `Esc or b or ←: Back to list`
- After: `Esc/a/b/←: Back to list`

## Rationale

- **Consistency**: WASD is familiar to gamers and provides a consistent directional layout
- **Ergonomics**: WASD keys are positioned for left-hand operation, leaving right hand free for other operations
- **Simplicity**: Two clear options (WASD or arrows) instead of multiple overlapping keybindings
- **Modern Standard**: WASD + arrows is the common pattern in modern TUIs and games

## Testing

To test the new keymaps:

1. Start the TUI: `./index.tsx`
2. In card list view:
   - Press `w` to move up
   - Press `s` to move down
   - Press `d` to go to next page
   - Press `a` to go to previous page
3. Select a card (Enter)
4. In card detail view:
   - Press `a` to go back to list

All WASD keys should work alongside existing keybindings.
