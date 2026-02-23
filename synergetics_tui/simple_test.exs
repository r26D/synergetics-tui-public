#!/usr/bin/env elixir

# Very simple test to see if we can read from /dev/tty

IO.puts("Simple /dev/tty test")
IO.puts("====================")
IO.puts("")

case :file.open("/dev/tty", [:read, :raw, :binary]) do
  {:ok, tty} ->
    IO.puts("✅ Opened /dev/tty in raw mode")
    IO.puts("Type: #{inspect(tty)}")
    IO.puts("")
    IO.puts("Now I will try to read ONE character...")
    IO.puts("Press ANY key:")
    IO.puts("")
    
    # Try to read with a timeout using Task
    task = Task.async(fn ->
      :file.read(tty, 1)
    end)
    
    case Task.yield(task, 5000) do
      {:ok, {:ok, char}} ->
        IO.puts("")
        IO.puts("✅ SUCCESS! Read character: #{inspect(char)}")
        IO.puts("Bytes: #{inspect(:binary.bin_to_list(char))}")
        
      {:ok, other} ->
        IO.puts("")
        IO.puts("❌ Read returned: #{inspect(other)}")
        
      nil ->
        IO.puts("")
        IO.puts("❌ TIMEOUT! The read is blocking.")
        IO.puts("This means /dev/tty is NOT in raw mode.")
        Task.shutdown(task, :brutal_kill)
    end
    
    :file.close(tty)
    
  {:error, reason} ->
    IO.puts("❌ Failed to open /dev/tty: #{inspect(reason)}")
end

IO.puts("")
IO.puts("Test complete!")

