#!/usr/bin/env elixir

# Test that the TUI can start up and access the database
# This doesn't run the interactive loop, just verifies the components work

Mix.install([{:exqlite, "~> 0.27"}])

# Load the modules
Code.require_file("lib/synergetics_tui/database.ex")

alias SynergeticsTui.Database

IO.puts("Testing TUI startup...")
IO.puts("")

case Database.open() do
  {:ok, conn} ->
    IO.puts("✓ Database connection successful")
    
    count = Database.count_cards(conn)
    IO.puts("✓ Card count: #{count}")
    
    cards = Database.list_cards(conn, limit: 5, offset: 0)
    IO.puts("✓ Loaded #{length(cards)} cards")
    
    if length(cards) > 0 do
      first = List.first(cards)
      IO.puts("✓ First card: #{first.id} - #{first.title}")
      
      full = Database.get_card(conn, first.id)
      if full do
        IO.puts("✓ Retrieved full card details")
      end
    end
    
    Database.close(conn)
    IO.puts("✓ Database closed")
    IO.puts("")
    IO.puts("✅ All startup tests passed!")
    IO.puts("")
    IO.puts("The TUI should work correctly. Run it with:")
    IO.puts("  ./run_tui.sh")
    IO.puts("or")
    IO.puts("  cd synergetics_tui && mix tui")
    
  {:error, reason} ->
    IO.puts("✗ Error: #{reason}")
    System.halt(1)
end

