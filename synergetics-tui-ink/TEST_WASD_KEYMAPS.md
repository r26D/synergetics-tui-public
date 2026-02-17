# WASD Keymaps Test Plan

## Test Date
February 16, 2026

## Test Objective
Verify that WASD keymaps work correctly in the Synergetics Dictionary TUI alongside existing keybindings.

## Test Environment
- Application: `synergetics-tui-ink`
- Files Modified:
  - `components/CardList.tsx`
  - `components/CardDetail.tsx`

## Test Cases

### 1. Card List Navigation (Up/Down)

| Test | Key | Expected Result | Status |
|------|-----|----------------|--------|
| 1.1 | Press `w` | Cursor moves up one card | ⏳ Pending |
| 1.2 | Press `s` | Cursor moves down one card | ⏳ Pending |
| 1.3 | Press `↑` | Cursor moves up (arrow key) | ⏳ Pending |
| 1.4 | Press `↓` | Cursor moves down (arrow key) | ⏳ Pending |

### 2. Card List Pagination (Left/Right)

| Test | Key | Expected Result | Status |
|------|-----|----------------|--------|
| 2.1 | Press `a` | Go to previous page | ⏳ Pending |
| 2.2 | Press `d` | Go to next page | ⏳ Pending |
| 2.3 | Press `←` | Go to previous page (arrow key) | ⏳ Pending |
| 2.4 | Press `→` | Go to next page (arrow key) | ⏳ Pending |

### 3. Card Detail Back Navigation

| Test | Key | Expected Result | Status |
|------|-----|----------------|--------|
| 3.1 | Press `a` | Return to card list | ⏳ Pending |
| 3.2 | Press `b` | Return to card list (existing) | ⏳ Pending |
| 3.3 | Press `←` | Return to card list (existing) | ⏳ Pending |
| 3.4 | Press `Esc` | Return to card list (existing) | ⏳ Pending |

### 4. No Key Conflicts

| Test | Key | Expected Result | Status |
|------|-----|----------------|--------|
| 4.1 | Press `q` | Quit application (not affected) | ⏳ Pending |
| 4.2 | Press `r` | Refresh list (not affected) | ⏳ Pending |
| 4.3 | Press `g` | Go to card (not affected) | ⏳ Pending |
| 4.4 | Press `/` | Search cards (not affected) | ⏳ Pending |
| 4.5 | Press `Enter` | Select card (not affected) | ⏳ Pending |

### 5. Help Text Display

| Test | View | Expected Result | Status |
|------|------|----------------|--------|
| 5.1 | Card List | Shows `w/s/↑/↓: Navigate` | ⏳ Pending |
| 5.2 | Card List | Shows `a/d/←/→: Prev/Next Page` | ⏳ Pending |
| 5.3 | Card Detail | Shows `Esc/a/b/←: Back to list` | ⏳ Pending |

## Manual Test Procedure

1. **Start the TUI:**
   ```bash
   cd synergetics-tui-ink
   npm start
   ```

2. **Test Card List Navigation:**
   - Press `w` multiple times → cursor should move up
   - Press `s` multiple times → cursor should move down
   - Verify `↑`, `↓` arrow keys still work

3. **Test Pagination:**
   - Press `d` → should go to next page
   - Press `a` → should go to previous page
   - Verify `←`, `→` arrow keys still work

4. **Test Card Detail:**
   - Select a card with `Enter`
   - Press `a` → should return to list
   - Select another card
   - Verify `b`, `←`, `Esc` still work

5. **Test Other Commands:**
   - Press `g` → should open go to card input
   - Press `Esc` → should return to list
   - Press `/` → should open search input
   - Press `Esc` → should return to list
   - Press `r` → should refresh list
   - Press `q` → should quit

6. **Verify Help Text:**
   - Check that help text at bottom shows all key options
   - Verify text is readable and not truncated

## Expected Results

- ✅ All WASD keys work as specified
- ✅ Arrow keys continue to work
- ✅ j/k/p/n keys no longer function (removed)
- ✅ No key conflicts or unexpected behavior
- ✅ Help text accurately reflects available keys
- ✅ User can mix WASD and arrow keys

## Notes

- WASD keys replace j/k/p/n for simpler, clearer navigation
- Arrow keys remain as alternative to WASD
- Two clear options: WASD (gaming-style) or arrows (traditional)
- Help text is cleaner with fewer key options shown

## Sign-off

- [ ] All tests passed
- [ ] No regressions found
- [ ] Documentation updated
- [ ] Ready for use

---

**Tester:** _________________  
**Date:** _________________
