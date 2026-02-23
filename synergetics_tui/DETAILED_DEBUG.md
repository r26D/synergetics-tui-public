# Detailed Debug Output

## What's Been Added

I've added very detailed debug output at every step of the input process:

1. **At startup** - Shows if /dev/tty opened
2. **When reading starts** - Shows which input device is being used
3. **For each character** - Shows exactly what was read
4. **For each command** - Shows what command is being returned
5. **For escape sequences** - Shows each step of arrow key detection

## How to Test

Run the TUI:
```bash
./run_tui.sh
```

## What to Look For

### At Startup

You should see:
```
DEBUG: /dev/tty opened in raw mode successfully
DEBUG: input_device = {:file_descriptor, ...}, raw_tty = true
```

### When You Press a Key

#### For letter 'j':
```
DEBUG: Reading from file descriptor...
DEBUG: Read from FD: "j", bytes: [106]
DEBUG: Received char: "j", bytes: [106]
DEBUG: Down command (j)
DEBUG: Returning command: :down
```

#### For down arrow:
```
DEBUG: Reading from file descriptor...
DEBUG: Read from FD: "\e", bytes: [27]
DEBUG: Received char: "\e", bytes: [27]
DEBUG: Escape detected, reading more...
DEBUG: Reading from file descriptor...
DEBUG: Read from FD: "[", bytes: [91]
DEBUG: Got [, reading arrow key...
DEBUG: Reading from file descriptor...
DEBUG: Read from FD: "B", bytes: [66]
DEBUG: Down arrow!
DEBUG: Returning command: :down
```

#### For 'b' (back):
```
DEBUG: Reading from file descriptor...
DEBUG: Read from FD: "b", bytes: [98]
DEBUG: Received char: "b", bytes: [98]
DEBUG: Returning command: :back
```

## Possible Issues

### Issue 1: Not Reading from File Descriptor

If you see:
```
DEBUG: Reading from standard_io...
```

This means it's not using /dev/tty. The TUI will fall back to line-based input.

### Issue 2: Wrong Bytes Received

If the bytes don't match what's expected:
- 'j' should be [106]
- 'k' should be [107]
- 'b' should be [98]
- Down arrow should be [27, 91, 66]
- Up arrow should be [27, 91, 65]

### Issue 3: Read Blocks or Hangs

If it says "Reading from file descriptor..." but never shows "Read from FD:", the read is blocking. This might mean the terminal isn't in raw mode.

### Issue 4: Command Not Recognized

If you see the character but not the command, there's a pattern matching issue.

## What to Report

Please run the TUI and try these actions, then share ALL the debug output:

1. **Press 'j' once**
   - Share all debug output

2. **Press down arrow once**
   - Share all debug output

3. **Press Enter to view a card**
   - Share all debug output

4. **Press 'b' to go back**
   - Share all debug output

## Expected Flow

For a working system:

1. Press 'j'
   → Reads "j" from FD
   → Recognizes as :down command
   → Cursor moves down

2. Press down arrow
   → Reads "\e" from FD
   → Reads "[" from FD
   → Reads "B" from FD
   → Recognizes as :down command
   → Cursor moves down

3. Press 'b' in detail view
   → Reads "b" from FD
   → Recognizes as :back command
   → Returns to list view

## Next Steps

Once we see the debug output, we'll know:
- Is it reading from the right device?
- Are the right bytes being received?
- Are commands being recognized?
- Where exactly is it failing?

Then we can fix the specific issue!

