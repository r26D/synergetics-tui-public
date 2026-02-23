# Fix Applied: stty with /dev/tty

## Problem

The instant input wasn't working because `System.cmd("stty", ...)` doesn't have access to the terminal when run from within an Elixir application. The `stty` command needs to operate on the actual terminal device.

## Solution

Changed from:
```elixir
System.cmd("stty", ["-icanon", "min", "1", "time", "0"])
```

To:
```elixir
System.shell("stty -icanon -echo min 1 time 0 < /dev/tty")
```

The key difference:
- `System.cmd` runs the command but doesn't connect it to the terminal
- `System.shell` with `< /dev/tty` explicitly connects stty to the terminal device
- `/dev/tty` is the current terminal device file

## What This Does

**`stty -icanon -echo min 1 time 0 < /dev/tty`**

- `-icanon` - Disable canonical mode (line buffering)
- `-echo` - Disable echo (don't show typed characters)
- `min 1` - Read returns after 1 character
- `time 0` - No timeout (return immediately)
- `< /dev/tty` - Apply to the current terminal

## Testing

Now when you run:
```bash
./run_tui.sh
```

All keys should work instantly:
- Arrow keys (↑/↓/←/→) - instant navigation
- Letter commands (j/k/n/p/q) - instant response
- Search typing - real-time
- Backspace - works immediately

## Technical Details

The issue was that `System.cmd/3` spawns a new process with its own stdin/stdout/stderr, which aren't connected to the terminal. The `stty` command needs to operate on the actual terminal device to change its mode.

By using `System.shell/1` with `< /dev/tty`, we redirect the terminal device as input to the `stty` command, allowing it to change the terminal settings.

## Verification

After starting the TUI, you should be able to:
1. Press any key and see immediate response
2. No need to press Enter
3. No visible escape sequences
4. Terminal restored properly on exit

If it still doesn't work, please check:
- Does `/dev/tty` exist? Run: `ls -l /dev/tty`
- What's your shell? Run: `echo $SHELL`
- Try running manually: `stty -icanon -echo min 1 time 0 < /dev/tty`

## Restoration

On exit, the TUI runs:
```elixir
System.shell("stty icanon echo < /dev/tty")
```

This restores:
- `icanon` - Re-enable canonical mode
- `echo` - Re-enable echo
- `< /dev/tty` - Apply to the terminal

If the terminal gets messed up, you can manually restore it:
```bash
stty sane
reset
```

