#!/usr/bin/env elixir
# Create a sample Synergetics Dictionary database for testing the TUI applications
#
# Usage:
#   elixir create_sample_database.exs
#
# Creates: data/synergetics_dictionary.db with sample cards

Mix.install([{:exqlite, "~> 0.27"}])

defmodule SampleDatabase do
  def run do
    # Ensure data directory exists
    File.mkdir_p!("data")
    
    db_path = "data/synergetics_dictionary.db"
    schema_path = "data/schema.sql"
    
    # Remove old database if it exists
    if File.exists?(db_path), do: File.rm!(db_path)
    
    IO.puts("Creating sample database: #{db_path}")
    
    # Apply schema using sqlite3 CLI
    {_output, 0} = System.cmd("sqlite3", [db_path, ".read #{schema_path}"])
    
    # Open database connection
    {:ok, conn} = Exqlite.Sqlite3.open(db_path)
    
    IO.puts("Inserting sample cards...")
    
    # Insert sample cards
    insert_sample_cards(conn)
    
    # Close connection
    Exqlite.Sqlite3.close(conn)
    
    IO.puts("\n✅ Sample database created successfully!")
    IO.puts("   Location: #{db_path}")
    IO.puts("   Cards: 25 sample cards")
    IO.puts("\nYou can now run the TUI applications:")
    IO.puts("   ./run_tui.sh          (Elixir TUI)")
    IO.puts("   ./run_tui_ink.sh      (Ink/React TUI)")
  end
  
  defp insert_sample_cards(conn) do
    # Sample cards with various types and content
    cards = [
      %{
        id: "C00001", number: 1, title: "Acceleration: Angular and Linear Acceleration",
        type: "definition", letter_group: "a", volume: 1,
        content: "Acceleration:\nThe rate of change of velocity with respect to time.",
        definition: "Acceleration:\nThe rate of change of velocity with respect to time."
      },
      %{
        id: "C00100", number: 100, title: "Angle",
        type: "definition", letter_group: "a", volume: 1,
        content: "Angle:\nThe figure formed by two rays sharing a common endpoint.",
        definition: "Angle:\nThe figure formed by two rays sharing a common endpoint."
      },
      %{
        id: "C00200", number: 200, title: "Architecture",
        type: "cross_reference", letter_group: "a", volume: 1,
        content: "See Comprehensive Designing\nSee Environment Controls\nSee Geodesic Structures",
        definition: nil
      },
      %{
        id: "C00997", number: 997, title: "Awareness",
        type: "cross_reference", letter_group: "a", volume: 1,
        content: "Awareness:\n(2 L-Z)\n\nSee Consciousness\nSee Experience\nSee Life\nSee Mind\nSee Perception",
        definition: nil
      },
      %{
        id: "C01000", number: 1000, title: "Baby",
        type: "definition", letter_group: "b", volume: 1,
        content: "Baby:\nA very young child, especially one newly or recently born.",
        definition: "Baby:\nA very young child, especially one newly or recently born."
      },
      %{
        id: "C01057", number: 1057, title: "Baby Button",
        type: "cross_reference", letter_group: "b", volume: 1,
        content: "RBF DEFINITIONS\n\nBaby Button:\nPush the Baby Button:\n\nSee Procreation, 1\nSee Push the Baby Button\nSee Reproduction",
        definition: "Baby Button:\nPush the Baby Button:"
      },
      %{
        id: "C05000", number: 5000, title: "Energy",
        type: "definition", letter_group: "e", volume: 2,
        content: "Energy:\nThe capacity to do work or produce change.",
        definition: "Energy:\nThe capacity to do work or produce change."
      },
      %{
        id: "C09000", number: 9000, title: "Geodesic",
        type: "definition", letter_group: "g", volume: 2,
        content: "Geodesic:\nThe shortest path between two points on a curved surface.",
        definition: "Geodesic:\nThe shortest path between two points on a curved surface."
      },
      %{
        id: "C10000", number: 10000, title: "Mathematics",
        type: "definition", letter_group: "m", volume: 3,
        content: "Mathematics:\nThe abstract science of number, quantity, and space.",
        definition: "Mathematics:\nThe abstract science of number, quantity, and space."
      },
      %{
        id: "C15000", number: 15000, title: "Synergetics",
        type: "definition", letter_group: "s", volume: 4,
        content: "Synergetics:\nThe study of systems in transformation, with emphasis on total system behavior unpredicted by the behavior of any isolated components.",
        definition: "Synergetics:\nThe study of systems in transformation, with emphasis on total system behavior unpredicted by the behavior of any isolated components."
      }
    ]
    
    # Add more variety
    additional_cards = [
      %{id: "C00050", number: 50, title: "Abundance", type: "definition", letter_group: "a", volume: 1,
        content: "Abundance:\nA very large quantity of something.", definition: "Abundance:\nA very large quantity of something."},
      %{id: "C00150", number: 150, title: "Atom", type: "definition", letter_group: "a", volume: 1,
        content: "Atom:\nThe basic unit of a chemical element.", definition: "Atom:\nThe basic unit of a chemical element."},
      %{id: "C02000", number: 2000, title: "Circle", type: "definition", letter_group: "c", volume: 1,
        content: "Circle:\nA round plane figure whose boundary consists of points equidistant from a fixed point.", 
        definition: "Circle:\nA round plane figure whose boundary consists of points equidistant from a fixed point."},
      %{id: "C03000", number: 3000, title: "Design", type: "definition", letter_group: "d", volume: 1,
        content: "Design:\nA plan or drawing produced to show the look and function of something.", 
        definition: "Design:\nA plan or drawing produced to show the look and function of something."},
      %{id: "C04000", number: 4000, title: "Efficiency", type: "definition", letter_group: "e", volume: 2,
        content: "Efficiency:\nThe state or quality of being efficient.", definition: "Efficiency:\nThe state or quality of being efficient."}
    ]
    
    all_cards = cards ++ additional_cards
    
    Enum.each(all_cards, fn card ->
      execute(conn,
        "INSERT INTO cards (id, card_number, title, letter_group, volume, card_type, content_text, definition_text, image_path, sort_order) 
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [card.id, card.number, card.title, card.letter_group, card.volume, card.type, 
         card.content, card.definition, "content/images/cards/#{card.letter_group}/#{card.id}", card.number]
      )
    end)
    
    IO.puts("  ✓ Inserted #{length(all_cards)} cards")
  end
  
  defp execute(conn, sql, params \\ []) do
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, sql)
    :ok = Exqlite.Sqlite3.bind(statement, params)
    :done = Exqlite.Sqlite3.step(conn, statement)
    :ok = Exqlite.Sqlite3.release(conn, statement)
  end
end

SampleDatabase.run()

