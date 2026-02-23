#!/usr/bin/env elixir

# Test raw input directly

IO.puts("Testing raw input...")
IO.puts("")

# Try to open /dev/tty
case :file.open("/dev/tty", [:read, :raw, :binary]) do
  {:ok, tty} ->
    IO.puts("✅ Opened /dev/tty successfully")
    
    # Set raw mode
    {output, code} = System.shell("stty -icanon -echo min 1 time 0 < /dev/tty 2>&1")
    IO.puts("stty command result: code=#{code}, output=#{inspect(output)}")
    
    if code == 0 do
      IO.puts("✅ Raw mode enabled")
      IO.puts("")
      IO.puts("Press a key (will read instantly):")
      
      # Read one character
      case :file.read(tty, 1) do
        {:ok, char} ->
          IO.puts("")
          IO.puts("Received: #{inspect(char)}")
          IO.puts("Bytes: #{inspect(:binary.bin_to_list(char))}")
          
          # If it's escape, try to read the full sequence
          if char == "\e" do
            IO.puts("Escape detected, reading more...")
            case :file.read(tty, 1) do
              {:ok, second} ->
                IO.puts("Second char: #{inspect(second)}")
                if second == "[" do
                  case :file.read(tty, 1) do
                    {:ok, third} ->
                      IO.puts("Third char: #{inspect(third)}")
                      arrow = case third do
                        "A" -> "Up Arrow"
                        "B" -> "Down Arrow"
                        "C" -> "Right Arrow"
                        "D" -> "Left Arrow"
                        _ -> "Unknown"
                      end
                      IO.puts("Detected: #{arrow}")
                    other ->
                      IO.puts("Failed to read third: #{inspect(other)}")
                  end
                end
              other ->
                IO.puts("Failed to read second: #{inspect(other)}")
            end
          end
          
        other ->
          IO.puts("Failed to read: #{inspect(other)}")
      end
      
      # Restore
      System.shell("stty icanon echo < /dev/tty 2>&1")
      IO.puts("")
      IO.puts("✅ Terminal restored")
    else
      IO.puts("❌ Failed to set raw mode")
    end
    
    :file.close(tty)
    
  {:error, reason} ->
    IO.puts("❌ Failed to open /dev/tty: #{inspect(reason)}")
end

IO.puts("")
IO.puts("Test complete!")

