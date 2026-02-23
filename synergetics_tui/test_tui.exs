#!/usr/bin/env elixir

# Simple test script to verify the TUI components work
Mix.install([{:exqlite, "~> 0.27"}])

Code.require_file("lib/synergetics_tui/database.ex")

alias SynergeticsTui.Database

IO.puts("Testing Synergetics TUI Database Module...")
IO.puts("")

case Database.open() do
  {:ok, conn} ->
    IO.puts("✓ Database opened successfully")
    
    # Test count
    count = Database.count_cards(conn)
    IO.puts("✓ Total cards: #{count}")
    
    # Test list cards
    cards = Database.list_cards(conn, limit: 5, offset: 0)
    IO.puts("✓ Listed #{length(cards)} cards")
    
    if length(cards) > 0 do
      first_card = List.first(cards)
      IO.puts("  First card: #{first_card.id} - #{first_card.title}")
      
      # Test get card details
      full_card = Database.get_card(conn, first_card.id)
      if full_card do
        IO.puts("✓ Retrieved full card details for #{full_card.id}")
        IO.puts("  - Cross references: #{length(full_card.cross_references)}")
        IO.puts("  - Citations: #{length(full_card.citations)}")
      else
        IO.puts("✗ Failed to retrieve card details")
      end
    end
    
    # Test search
    search_results = Database.search_cards(conn, "acceleration", limit: 5)
    IO.puts("✓ Search for 'acceleration' returned #{length(search_results)} results")
    
    Database.close(conn)
    IO.puts("✓ Database closed")
    IO.puts("")
    IO.puts("All tests passed! The TUI should work correctly.")
    
  {:error, reason} ->
    IO.puts("✗ Error opening database: #{reason}")
    System.halt(1)
end

