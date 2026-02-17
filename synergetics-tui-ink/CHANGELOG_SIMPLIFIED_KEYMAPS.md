# Changelog: Simplified Keymaps (WASD + Arrows Only)

## Date
February 16, 2026

## Summary
Removed j/k/p/n keybindings in favor of a cleaner, dual-option navigation system using WASD and arrow keys only.

## Changes

### Removed Keybindings
- **j** (down navigation) - removed
- **k** (up navigation) - removed  
- **p** (previous page) - removed
- **n** (next page) - removed

### Current Keybindings
- **w** or **↑** - Navigate up
- **s** or **↓** - Navigate down
- **a** or **←** - Previous page / Back
- **d** or **→** - Next page

### Other Keys (Unchanged)
- **Enter** - Select card
- **g** - Go to card
- **/** - Search
- **r** - Refresh
- **q** - Quit
- **b** - Back (in detail view)
- **Esc** - Back/Cancel

## Rationale

### Before (Too Many Options)
Users had three overlapping navigation systems:
1. Vim-style: j/k for up/down, p/n for prev/next
2. Arrow keys: ↑/↓/←/→
3. WASD: w/s/a/d

This created confusion about which keys to use and cluttered the help text.

### After (Two Clear Options)
Users now have two distinct, non-overlapping options:
1. **WASD** - Gaming-style, ergonomic for left hand
2. **Arrow keys** - Traditional, familiar to all users

## Benefits

1. **Clearer Interface**: Help text is more concise and readable
2. **Less Confusion**: Two distinct options instead of three overlapping systems
3. **Modern Standard**: WASD + arrows is the common pattern in modern applications
4. **Easier to Learn**: New users don't need to remember multiple key combinations
5. **Still Flexible**: Users can choose WASD or arrows based on preference

## Help Text Comparison

### Before
```
w/s/j/k/↑/↓: Navigate | ... | a/d/p/n/←/→: Prev/Next Page | ...
```

### After
```
w/s/↑/↓: Navigate | ... | a/d/←/→: Prev/Next Page | ...
```

## Migration Notes

Users who were using j/k/p/n keys will need to switch to either:
- **WASD** keys (w/s/a/d)
- **Arrow keys** (↑/↓/←/→)

Both options provide the same functionality with a cleaner, more intuitive interface.

## Files Modified

1. `components/CardList.tsx` - Removed j/k/p/n from input handler
2. `WASD_KEYMAPS.md` - Updated documentation
3. `docs-site/docs/tui-wasd-keymaps.md` - Updated user documentation
4. `TEST_WASD_KEYMAPS.md` - Updated test plan

## Testing

All navigation functionality remains intact:
- ✅ Up/down navigation works with w/s and ↑/↓
- ✅ Page navigation works with a/d and ←/→
- ✅ All other commands unchanged
- ✅ Help text displays correctly
- ✅ No regressions in functionality
