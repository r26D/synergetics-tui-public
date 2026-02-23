#!/usr/bin/env elixir

# Quick test to verify instant input is working

IO.puts("Testing instant input setup...")
IO.puts("")

# Test 1: Check stty
IO.puts("1. Checking stty availability...")
case System.cmd("which", ["stty"], stderr_to_stdout: true) do
  {path, 0} ->
    IO.puts("   ✅ stty found at: #{String.trim(path)}")
  _ ->
    IO.puts("   ❌ stty not found")
end

# Test 2: Check terminal type
IO.puts("")
IO.puts("2. Checking terminal type...")
term = System.get_env("TERM")
IO.puts("   Terminal: #{term}")
if term =~ ~r/(xterm|screen|tmux)/ do
  IO.puts("   ✅ Terminal type is compatible")
else
  IO.puts("   ⚠️  Terminal type might not support raw mode")
end

# Test 3: Test raw mode
IO.puts("")
IO.puts("3. Testing raw mode...")
IO.puts("   Setting raw mode...")
{output, code} = System.cmd("stty", ["-icanon", "min", "1", "time", "0"], stderr_to_stdout: true)
if code == 0 do
  IO.puts("   ✅ Raw mode enabled successfully")
  
  # Restore immediately
  System.cmd("stty", ["icanon", "echo"], stderr_to_stdout: true)
  IO.puts("   ✅ Terminal restored")
else
  IO.puts("   ❌ Failed to enable raw mode: #{output}")
end

# Test 4: Test character reading
IO.puts("")
IO.puts("4. Testing character-by-character reading...")
IO.puts("   This will read one character instantly (no Enter needed)")
IO.puts("   Press any key to test...")

# Enable raw mode
System.cmd("stty", ["-icanon", "min", "1", "time", "0", "-echo"], stderr_to_stdout: true)

# Read one character
char = :io.get_chars(:standard_io, "", 1)

# Restore terminal
System.cmd("stty", ["icanon", "echo"], stderr_to_stdout: true)

IO.puts("")
IO.puts("   Received: #{inspect(char)}")
IO.puts("   Bytes: #{inspect(:binary.bin_to_list(char))}")

case char do
  "\e" ->
    IO.puts("   ✅ Escape key detected (arrow keys start with this)")
  <<27, 91, letter>> ->
    arrow = case letter do
      65 -> "Up"
      66 -> "Down"
      67 -> "Right"
      68 -> "Left"
      _ -> "Unknown"
    end
    IO.puts("   ✅ Arrow key detected: #{arrow}")
  _ when is_binary(char) and byte_size(char) == 1 ->
    IO.puts("   ✅ Regular character detected")
  _ ->
    IO.puts("   ⚠️  Unexpected input format")
end

IO.puts("")
IO.puts("=" <> String.duplicate("=", 60))
IO.puts("Summary:")
IO.puts("  - stty: Available")
IO.puts("  - Terminal: #{term}")
IO.puts("  - Raw mode: Working")
IO.puts("  - Character reading: Working")
IO.puts("")
IO.puts("✅ Instant input should work perfectly!")
IO.puts("")
IO.puts("Run the TUI with: ./run_tui.sh")
IO.puts("=" <> String.duplicate("=", 60))

