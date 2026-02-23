# New Approach: Using standard_io with stty

## The Problem We Found

The simple test revealed the issue:
```
** (ErlangError) Erlang error: :not_on_controlling_process
```

This means that file descriptors opened with `:file.open` can only be read from the process that opened them. This is an Erlang limitation.

## The New Solution

Instead of opening `/dev/tty` as a file descriptor, we now:

1. **Use `standard_io` directly** - This is already connected to the terminal
2. **Use `stty` to set raw mode** - But apply it to `/dev/tty` using the `-f` flag
3. **Read from `standard_io`** - Which avoids the controlling process issue

## The Key Change

**Old approach (didn't work):**
```elixir
:file.open("/dev/tty", [:read, :raw, :binary])  # ❌ Controlling process issue
:file.read(tty, 1)
```

**New approach:**
```elixir
System.shell("stty -f /dev/tty -icanon -echo")  # ✅ Set raw mode on the terminal
:io.get_chars(:standard_io, "", 1)              # ✅ Read from standard_io
```

## Why This Should Work

- `stty -f /dev/tty` applies settings directly to the terminal device
- `standard_io` is already connected to the terminal
- No controlling process issues
- Should work with `mix tui`

## Testing

Run the TUI:
```bash
./run_tui.sh
```

You should see:
```
DEBUG: Attempting to set raw mode on standard_io...
DEBUG: ✅ stty succeeded - terminal is in raw mode
```

Then when you press keys, you should see them being read instantly.

## Fallback

The code tries two stty commands:
1. `stty -f /dev/tty -icanon -echo` (BSD/macOS style)
2. `stty -icanon -echo` (Linux style)

One of them should work on your system.

## Expected Behavior

Now when you press keys:
- Characters should be read immediately
- Arrow keys should send escape sequences
- All commands should work instantly
- No need to press Enter

## If It Still Doesn't Work

If stty still fails, we'll need to try a completely different approach, possibly:
- Using a different terminal library
- Using NIFs (Native Implemented Functions)
- Using ports to communicate with a C program
- Accepting that instant input might not be possible in this environment

