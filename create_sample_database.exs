#!/usr/bin/env elixir
# Create a sample Synergetics Dictionary database for testing the TUI applications
#
# Usage:
#   elixir create_sample_database.exs [source_db_path]
#
# If source_db_path is provided, copies all letter group 'a' cards from that database.
# Otherwise, creates a minimal sample database with a few example cards.
#
# Creates: data/synergetics_dictionary.db with sample cards

Mix.install([{:exqlite, "~> 0.27"}])

defmodule SampleDatabase do
  def run do
    # Ensure data directory exists
    File.mkdir_p!("data")

    db_path = "data/synergetics_dictionary.db"
    schema_path = "data/schema.sql"
    source_db_path = System.argv() |> List.first()

    # Remove old database if it exists
    if File.exists?(db_path), do: File.rm!(db_path)

    IO.puts("Creating sample database: #{db_path}")

    # Apply schema using sqlite3 CLI
    {_output, 0} = System.cmd("sqlite3", [db_path, ".read #{schema_path}"])

    # Open database connection
    {:ok, conn} = Exqlite.Sqlite3.open(db_path)

    # Check if we should copy from source database
    if source_db_path && File.exists?(source_db_path) do
      IO.puts("Copying letter group 'a' cards from: #{source_db_path}")
      copy_letter_group_a(conn, source_db_path)
    else
      if source_db_path do
        IO.puts("⚠ Source database not found: #{source_db_path}")
        IO.puts("Creating minimal sample database instead...")
      else
        IO.puts("Creating minimal sample database...")
      end
      insert_sample_cards(conn)
    end

    # Close connection
    Exqlite.Sqlite3.close(conn)

    IO.puts("\n✅ Sample database created successfully!")
    IO.puts("   Location: #{db_path}")
    IO.puts("\nYou can now run the TUI applications:")
    IO.puts("   ./run_tui.sh          (Elixir TUI)")
    IO.puts("   ./run_tui_ink.sh      (Ink/React TUI)")
  end

  defp copy_letter_group_a(dest_conn, source_db_path) do
    # Open source database
    {:ok, source_conn} = Exqlite.Sqlite3.open(source_db_path)

    # Get all cards from letter group 'a'
    cards_query = """
    SELECT id, card_number, title, letter_group, volume, card_type,
           reference_level, reference_level_label, content_text,
           definition_text, image_path, sort_order, needs_review,
           review_notes, reviewed_at
    FROM cards
    WHERE letter_group = 'a'
    ORDER BY card_number
    """

    {:ok, statement} = Exqlite.Sqlite3.prepare(source_conn, cards_query)
    cards = fetch_all_rows(source_conn, statement)
    Exqlite.Sqlite3.release(source_conn, statement)

    IO.puts("  Found #{length(cards)} cards in letter group 'a'")

    # Insert cards
    Enum.each(cards, fn card ->
      [id, card_number, title, letter_group, volume, card_type,
       reference_level, reference_level_label, content_text,
       definition_text, image_path, sort_order, needs_review,
       review_notes, reviewed_at] = card

      execute(dest_conn,
        "INSERT INTO cards (id, card_number, title, letter_group, volume, card_type,
                           reference_level, reference_level_label, content_text,
                           definition_text, image_path, sort_order, needs_review,
                           review_notes, reviewed_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [id, card_number, title, letter_group, volume, card_type,
         reference_level, reference_level_label, content_text,
         definition_text, image_path, sort_order, needs_review,
         review_notes, reviewed_at]
      )
    end)

    IO.puts("  ✓ Inserted #{length(cards)} cards")

    # Copy see_links for these cards
    see_links_query = """
    SELECT id, source_card_id, target_card_id, display_text, line_content,
           date_annotation, reference_levels, sort_order
    FROM see_links
    WHERE source_card_id IN (SELECT id FROM cards WHERE letter_group = 'a')
    """

    {:ok, statement} = Exqlite.Sqlite3.prepare(source_conn, see_links_query)
    see_links = fetch_all_rows(source_conn, statement)
    Exqlite.Sqlite3.release(source_conn, statement)

    Enum.each(see_links, fn link ->
      [_id, source_card_id, target_card_id, display_text, line_content,
       date_annotation, reference_levels, sort_order] = link

      execute(dest_conn,
        "INSERT INTO see_links (source_card_id, target_card_id, display_text,
                               line_content, date_annotation, reference_levels, sort_order)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
        [source_card_id, target_card_id, display_text, line_content,
         date_annotation, reference_levels, sort_order]
      )
    end)

    IO.puts("  ✓ Inserted #{length(see_links)} see links")

    # Copy citations for these cards
    citations_query = """
    SELECT id, card_id, citation_text, source_type, source_title, date, page, sort_order
    FROM citations
    WHERE card_id IN (SELECT id FROM cards WHERE letter_group = 'a')
    """

    {:ok, statement} = Exqlite.Sqlite3.prepare(source_conn, citations_query)
    citations = fetch_all_rows(source_conn, statement)
    Exqlite.Sqlite3.release(source_conn, statement)

    Enum.each(citations, fn citation ->
      [_id, card_id, citation_text, source_type, source_title, date, page, sort_order] = citation

      execute(dest_conn,
        "INSERT INTO citations (card_id, citation_text, source_type, source_title,
                               date, page, sort_order)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
        [card_id, citation_text, source_type, source_title, date, page, sort_order]
      )
    end)

    IO.puts("  ✓ Inserted #{length(citations)} citations")

    # Close source connection
    Exqlite.Sqlite3.close(source_conn)
  end

  defp fetch_all_rows(conn, statement, acc \\ []) do
    case Exqlite.Sqlite3.step(conn, statement) do
      {:row, row} -> fetch_all_rows(conn, statement, [row | acc])
      :done -> Enum.reverse(acc)
    end
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

