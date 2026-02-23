defmodule SynergeticsTui.Database do
  @moduledoc """
  Database module for querying the Synergetics Dictionary SQLite database.
  """

  @doc """
  Opens a connection to the database.
  Returns {:ok, conn} or {:error, reason}.
  """
  def open do
    # Try to find the database in the parent directory (when running from synergetics_tui)
    # or in the data directory (when running from project root)
    db_path =
      cond do
        File.exists?("../data/synergetics_dictionary.db") ->
          Path.expand("../data/synergetics_dictionary.db")
        File.exists?("data/synergetics_dictionary.db") ->
          Path.expand("data/synergetics_dictionary.db")
        true ->
          Path.expand("../data/synergetics_dictionary.db")
      end

    unless File.exists?(db_path) do
      {:error, "Database not found at #{db_path}. Run: elixir scripts/import_cards_to_sqlite.exs"}
    else
      Exqlite.Sqlite3.open(db_path)
    end
  end

  @doc """
  Closes the database connection.
  """
  def close(conn) do
    Exqlite.Sqlite3.close(conn)
  end

  @doc """
  Fetches all cards with pagination.
  Returns a list of card maps.
  """
  def list_cards(conn, opts \\ []) do
    limit = Keyword.get(opts, :limit, 50)
    offset = Keyword.get(opts, :offset, 0)

    sql = """
    SELECT id, title, letter_group, card_type, reference_level, reference_level_label, needs_review, review_notes, sort_order
    FROM cards
    ORDER BY sort_order
    LIMIT ?1 OFFSET ?2
    """

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [limit, offset])
        Exqlite.Sqlite3.release(conn, stmt)

        Enum.map(rows, fn [id, title, letter_group, card_type, ref_level, ref_label, needs_review, review_notes, sort_order] ->
          %{
            id: id,
            title: title,
            letter_group: letter_group,
            card_type: card_type,
            reference_level: ref_level,
            reference_level_label: ref_label,
            needs_review: needs_review == 1,
            review_notes: review_notes,
            sort_order: sort_order
          }
        end)

      {:error, reason} ->
        IO.puts("Error preparing query: #{inspect(reason)}")
        []
    end
  end

  @doc """
  Gets the total count of cards.
  """
  def count_cards(conn) do
    sql = "SELECT COUNT(*) FROM cards"

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [])
        Exqlite.Sqlite3.release(conn, stmt)

        case rows do
          [[count]] -> count
          _ -> 0
        end

      {:error, _reason} ->
        0
    end
  end

  @doc """
  Gets a single card by card number.
  Accepts various formats: 1924, C1924, C01924, 01924
  Returns the card map or nil if not found.
  """
  def get_card_by_number(conn, card_number) do
    # Normalize the card number to just the numeric part
    numeric_part =
      card_number
      |> to_string()
      |> String.replace(~r/^C0*/i, "")

    # Convert to integer
    case Integer.parse(numeric_part) do
      {num, _} ->
        sql = """
        SELECT id, card_number, title, letter_group, volume, card_type,
               reference_level, reference_level_label, content_text, definition_text,
               image_path, sort_order, reviewed_at, needs_review, review_notes
        FROM cards
        WHERE card_number = ?1
        """

        case Exqlite.Sqlite3.prepare(conn, sql) do
          {:ok, stmt} ->
            rows = execute_query(conn, stmt, [num])
            Exqlite.Sqlite3.release(conn, stmt)

            case rows do
              [[id, card_num, title, lg, vol, type, ref_lvl, ref_lbl, content, def_text, img, sort, reviewed, needs_review, review_notes]] ->
                %{
                  id: id,
                  card_number: card_num,
                  title: title,
                  letter_group: lg,
                  volume: vol,
                  card_type: type,
                  reference_level: ref_lvl,
                  reference_level_label: ref_lbl,
                  content_text: content,
                  definition_text: def_text,
                  image_path: img,
                  sort_order: sort,
                  reviewed_at: reviewed,
                  needs_review: needs_review,
                  review_notes: review_notes,
                  cross_references: get_cross_references(conn, id),
                  citations: get_citations(conn, id)
                }

              _ ->
                nil
            end

          {:error, _reason} ->
            nil
        end

      :error ->
        nil
    end
  end

  @doc """
  Gets a single card by ID with all details.
  """
  def get_card(conn, card_id) do
    sql = """
    SELECT id, card_number, title, letter_group, volume, card_type,
           reference_level, reference_level_label, content_text, definition_text,
           image_path, sort_order, reviewed_at, needs_review, review_notes
    FROM cards
    WHERE id = ?1
    """

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [card_id])
        Exqlite.Sqlite3.release(conn, stmt)

        case rows do
          [[id, card_num, title, lg, vol, type, ref_lvl, ref_lbl, content, def_text, img, sort, reviewed, needs_review, review_notes]] ->
            %{
              id: id,
              card_number: card_num,
              title: title,
              letter_group: lg,
              volume: vol,
              card_type: type,
              reference_level: ref_lvl,
              reference_level_label: ref_lbl,
              content_text: content,
              definition_text: def_text,
              image_path: img,
              sort_order: sort,
              reviewed_at: reviewed,
              needs_review: needs_review,
              review_notes: review_notes,
              cross_references: get_cross_references(conn, card_id),
              citations: get_citations(conn, card_id)
            }

          _ ->
            nil
        end

      {:error, _reason} ->
        nil
    end
  end

  @doc """
  Gets cross_references for a card.
  """
  def get_cross_references(conn, card_id) do
    sql = """
    SELECT id, target_card_id, display_text, line_content, date_annotation, reference_levels
    FROM cross_references
    WHERE source_card_id = ?1
    ORDER BY sort_order
    """

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [card_id])
        Exqlite.Sqlite3.release(conn, stmt)

        Enum.map(rows, fn [id, target, display, line, date, ref_lvls] ->
          %{id: id, target_card_id: target, display_text: display,
            line_content: line, date_annotation: date, reference_levels: ref_lvls}
        end)

      {:error, _reason} ->
        []
    end
  end

  @doc """
  Gets citations for a card.
  """
  def get_citations(conn, card_id) do
    sql = """
    SELECT id, citation_text, source_type, source_title, date, page
    FROM citations
    WHERE card_id = ?1
    ORDER BY sort_order
    """

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [card_id])
        Exqlite.Sqlite3.release(conn, stmt)

        Enum.map(rows, fn [id, text, src_type, src_title, date, page] ->
          %{id: id, citation_text: text, source_type: src_type,
            source_title: src_title, date: date, page: page}
        end)

      {:error, _reason} ->
        []
    end
  end

  @doc """
  Updates a card's fields.
  """
  def update_card(conn, card_id, fields) do
    # Build dynamic UPDATE query based on provided fields
    updates =
      fields
      |> Enum.map(fn {key, _value} -> "#{key} = ?" end)
      |> Enum.join(", ")

    values = Map.values(fields) ++ [card_id]

    sql = "UPDATE cards SET #{updates}, updated_at = CURRENT_TIMESTAMP WHERE id = ?"

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        result = Exqlite.Sqlite3.bind(stmt, values)

        case result do
          :ok ->
            step_result = Exqlite.Sqlite3.step(conn, stmt)
            Exqlite.Sqlite3.release(conn, stmt)

            case step_result do
              :done -> :ok
              {:error, reason} -> {:error, reason}
            end

          {:error, reason} ->
            Exqlite.Sqlite3.release(conn, stmt)
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Searches cards by title or content.
  """
  def search_cards(conn, query, opts \\ []) do
    limit = Keyword.get(opts, :limit, 50)
    search_term = "%#{query}%"

    sql = """
    SELECT id, title, letter_group, card_type, reference_level, reference_level_label, sort_order
    FROM cards
    WHERE title LIKE ?1 OR content_text LIKE ?1
    ORDER BY sort_order
    LIMIT ?2
    """

    case Exqlite.Sqlite3.prepare(conn, sql) do
      {:ok, stmt} ->
        rows = execute_query(conn, stmt, [search_term, limit])
        Exqlite.Sqlite3.release(conn, stmt)

        Enum.map(rows, fn [id, title, letter_group, card_type, ref_level, ref_label, sort_order] ->
          %{
            id: id,
            title: title,
            letter_group: letter_group,
            card_type: card_type,
            reference_level: ref_level,
            reference_level_label: ref_label,
            sort_order: sort_order
          }
        end)

      {:error, _reason} ->
        []
    end
  end

  # Private helper to execute a query and fetch all results
  defp execute_query(conn, stmt, params) do
    case Exqlite.Sqlite3.bind(stmt, params) do
      :ok ->
        fetch_all(conn, stmt, [])

      {:error, _reason} ->
        []
    end
  end

  defp fetch_all(conn, stmt, acc) do
    case Exqlite.Sqlite3.step(conn, stmt) do
      {:row, row} -> fetch_all(conn, stmt, [row | acc])
      :done -> Enum.reverse(acc)
      {:error, _} -> Enum.reverse(acc)
    end
  end
end
