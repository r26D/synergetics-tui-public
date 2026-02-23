# Debug Mode Enabled

## What I Did

I've added extensive debug output to the TUI to see exactly what's happening with the input.

## How to Test

### Option 1: Run the TUI with Debug Output

```bash
./run_tui.sh
```

When you press keys, you'll see debug messages like:
- `DEBUG: input_device = ...` - Shows what input device is being used
- `DEBUG: Received char: ...` - Shows each character received
- `DEBUG: Up arrow!` - Shows when arrow keys are detected
- `DEBUG: Down command (j)` - Shows when letter commands are detected

### Option 2: Run the Simple Test Script

```bash
cd synergetics_tui
elixir test_raw_input.exs
```

This will:
1. Open /dev/tty
2. Set raw mode
3. Wait for you to press ONE key
4. Show what was received
5. Restore terminal

## What to Look For

### When You Run the TUI

**At startup, you should see:**
```
DEBUG: input_device = #Port<...> (or {:file_descriptor, ...})
DEBUG: raw_tty = true
```

This confirms:
- ✅ /dev/tty was opened successfully
- ✅ Raw mode was attempted

**When you press a key, you should see:**
```
DEBUG: Received char: "j", bytes: [106]
DEBUG: Down command (j)
```

Or for arrow keys:
```
DEBUG: Received char: "\e", bytes: [27]
DEBUG: Escape detected, reading more...
DEBUG: Got [, reading arrow key...
DEBUG: Down arrow!
```

### Possible Issues

**If you see:**
```
DEBUG: Failed to open /dev/tty: ...
DEBUG: input_device = :standard_io
DEBUG: raw_tty = false
```
This means /dev/tty couldn't be opened. The TUI will fall back to standard_io which might not work in raw mode.

**If you see:**
```
DEBUG: stty failed with code 1: ...
```
This means the stty command failed to set raw mode.

**If characters appear but commands don't work:**
The debug output will show what's being received vs. what's expected.

## What to Report

After running the TUI, please tell me:

1. **What you see at startup:**
   - What is `input_device`?
   - What is `raw_tty`?
   - Any stty errors?

2. **When you press 'j':**
   - What does "Received char" show?
   - What does "bytes" show?
   - Does it say "Down command (j)"?
   - Does the cursor actually move?

3. **When you press down arrow:**
   - What does "Received char" show?
   - Does it say "Escape detected"?
   - Does it say "Down arrow!"?
   - Does the cursor actually move?

4. **When you press Enter:**
   - What does "Received char" show?
   - Does it say "Enter key"?
   - What happens?

## Next Steps

Once we see the debug output, we'll know exactly what's wrong:

- If characters aren't being received → input device issue
- If wrong characters are received → terminal encoding issue
- If right characters but wrong action → command mapping issue
- If stty fails → need different approach for raw mode

## Removing Debug Output

Once we fix the issue, I'll remove all the debug output and the 2-second delay at startup.

## Test the Simple Script First

Try the simple test script first:
```bash
cd synergetics_tui
elixir test_raw_input.exs
```

Press a key when prompted and see what it shows. This will tell us if raw mode is working at all.

