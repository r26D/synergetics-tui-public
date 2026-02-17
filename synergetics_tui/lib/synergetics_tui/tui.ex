defmodule SynergeticsTui.TUI do
  @moduledoc """
  Terminal User Interface for browsing and editing Synergetics Dictionary cards.
  """

  alias SynergeticsTui.{Database, InputHandler}

  defmodule State do
    @moduledoc false
    defstruct [
      :conn,
      :mode,           # :list, :detail, :edit, :search, :jump
      :cards,          # List of cards for current view
      :current_card,   # Currently selected card (full details)
      :selected_index, # Index in the cards list
      :offset,         # Pagination offset
      :total_count,    # Total number of cards
      :search_query,   # Current search query
      :jump_buffer,    # Buffer for jump input
      :edit_field,     # Field being edited
      :edit_buffer,    # Buffer for editing
      :message         # Status message to display
    ]
  end

  @page_size 20

  def start do
    case Database.open() do
      {:ok, conn} ->
        # Save original terminal settings
        original_tty = :io.getopts(:standard_io)

        # Also set Erlang I/O options for any fallback use of standard_io
        :io.setopts(:standard_io, [binary: true, echo: false, expand_fun: fn _ -> {:no, "", []} end])

        # Set Erlang I/O options for character-by-character reading
        # The terminal is already in raw mode (set by run_tui.sh before launching Mix)
        # binary: true - read as binary strings
        # echo: false - don't echo characters back
        # expand_fun - disable tab completion which can interfere
        :io.setopts(:standard_io, [
          binary: true,
          echo: false,
          expand_fun: fn _ -> {:no, "", []} end
        ])

        input_device = :standard_io

        total = Database.count_cards(conn)
        cards = Database.list_cards(conn, limit: @page_size, offset: 0)

        state = %State{
          conn: conn,
          mode: :list,
          cards: cards,
          current_card: nil,
          selected_index: 0,
          offset: 0,
          total_count: total,
          search_query: "",
          jump_buffer: "",
          edit_field: nil,
          edit_buffer: "",
          message: "Synergetics Dictionary TUI - #{total} cards loaded"
        }

        result = run_loop(state, input_device)

        # Restore standard_io settings
        :io.setopts(:standard_io, original_tty)

        result

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "Error: #{reason}" <> IO.ANSI.reset())
        :error
    end
  end

  defp run_loop(state, input_device) do
    clear_screen()
    render(state)

    case get_input(input_device) do
      :quit ->
        Database.close(state.conn)
        clear_screen()
        IO.puts("Goodbye!")
        :ok

      input ->
        new_state = InputHandler.handle_input(state, input)
        run_loop(new_state, input_device)
    end
  end

  defp clear_screen do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
  end

  defp render(%State{mode: :list} = state) do
    render_header(state)
    render_card_list(state)
    render_footer_list()
  end

  defp render(%State{mode: :detail} = state) do
    render_header(state)
    render_card_detail(state)
    render_footer_detail()
  end

  defp render(%State{mode: :edit} = state) do
    render_header(state)
    render_card_edit(state)
    render_footer_edit()
  end

  defp render(%State{mode: :search} = state) do
    render_header(state)
    render_search(state)
    render_footer_search()
  end

  defp render(%State{mode: :jump} = state) do
    render_header(state)
    render_jump(state)
    render_footer_jump()
  end

  defp render_header(state) do
    IO.puts(IO.ANSI.cyan() <> String.duplicate("=", 80) <> IO.ANSI.reset())
    IO.puts(IO.ANSI.bright() <> IO.ANSI.cyan() <>
            "  SYNERGETICS DICTIONARY TUI" <> IO.ANSI.reset())
    IO.puts(IO.ANSI.cyan() <> String.duplicate("=", 80) <> IO.ANSI.reset())

    if state.message do
      IO.puts(IO.ANSI.yellow() <> "  " <> state.message <> IO.ANSI.reset())
    end

    IO.puts("")
  end

  # Returns suffix string for reference level/label for use in card list and search (e.g. " (2B)" or " (1)").
  # Normalizes so we display labels like "A", "2B", "C1" even when reference_level is NULL.
  defp format_ref_level(card) do
    label = normalize_ref_value(Map.get(card, :reference_level_label))
    level = Map.get(card, :reference_level)
    cond do
      label != nil and label != "" -> " (#{label})"
      level != nil and level != "" -> " (#{level})"
      true -> ""
    end
  end

  defp normalize_ref_value(nil), do: nil
  defp normalize_ref_value(""), do: nil
  defp normalize_ref_value(s) when is_binary(s) do
    t = String.trim(s)
    if t == "", do: nil, else: t
  end
  defp normalize_ref_value(s) when is_list(s), do: normalize_ref_value(to_string(s))
  defp normalize_ref_value(s), do: normalize_ref_value(to_string(s))

  defp render_card_list(state) do
    IO.puts(IO.ANSI.bright() <>
            "Cards #{state.offset + 1}-#{min(state.offset + @page_size, state.total_count)} of #{state.total_count}" <>
            IO.ANSI.reset())
    IO.puts("")

    state.cards
    |> Enum.with_index()
    |> Enum.each(fn {card, index} ->
      prefix = if index == state.selected_index do
        IO.ANSI.green() <> "► "
      else
        "  "
      end

      ref_level = format_ref_level(card)
      review_indicator = if card.needs_review, do: " ⚠️ ", else: ""

      line = "#{prefix}#{card.id} - #{truncate(card.title, 60)}#{ref_level}#{review_indicator}"

      if index == state.selected_index do
        IO.puts(line <> IO.ANSI.reset())
      else
        IO.puts(line)
      end
    end)
  end

  defp render_footer_list do
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> String.duplicate("-", 80) <> IO.ANSI.reset())
    IO.puts("  ↑/↓ or j/k: Navigate  Enter: View  g: Jump to card  /: Search")
    IO.puts("  n/p or ←/→: Next/Prev Page  q: Quit")
    IO.puts(IO.ANSI.yellow() <> "  (All commands work instantly!)" <> IO.ANSI.reset())
  end




  defp render_card_detail(state) do
    card = state.current_card

    if card do
      IO.puts(IO.ANSI.bright() <> "Card: #{card.id}" <> IO.ANSI.reset())
      IO.puts(IO.ANSI.cyan() <> "Title: " <> IO.ANSI.reset() <> card.title)
      IO.puts("Type: #{card.card_type} | Group: #{card.letter_group} | Volume: #{card.volume || "N/A"}")

      ref_label = card.reference_level_label
      ref_level = card.reference_level
      show_ref = (is_binary(ref_label) and ref_label != "") or ref_level != nil
      if show_ref do
        label = if is_binary(ref_label) and ref_label != "", do: ref_label, else: "#{ref_level}"
        IO.puts("Reference Level: #{label}")
      end

      if card.needs_review do
        IO.puts("")
        IO.puts(IO.ANSI.yellow() <> "⚠️  NEEDS REVIEW: " <> IO.ANSI.reset() <> (card.review_notes || "This card needs manual review"))
      end

      IO.puts("")
      IO.puts(IO.ANSI.yellow() <> "Content:" <> IO.ANSI.reset())
      IO.puts(String.duplicate("-", 80))

      content = card.content_text || "(no content)"
      # Display first 15 lines of content
      content
      |> String.split("\n")
      |> Enum.take(15)
      |> Enum.each(&IO.puts/1)

      if card.definition_text do
        IO.puts("")
        IO.puts(IO.ANSI.yellow() <> "Definition:" <> IO.ANSI.reset())
        IO.puts(card.definition_text)
      end

      if length(card.see_links) > 0 do
        IO.puts("")
        IO.puts(IO.ANSI.yellow() <> "See Links (#{length(card.see_links)}):" <> IO.ANSI.reset())
        Enum.take(card.see_links, 5) |> Enum.each(fn link ->
          target = link.target_card_id || "unresolved"
          IO.puts("  → #{link.display_text} (#{target})")
        end)
      end

      if length(card.citations) > 0 do
        IO.puts("")
        IO.puts(IO.ANSI.yellow() <> "Citations (#{length(card.citations)}):" <> IO.ANSI.reset())
        Enum.take(card.citations, 3) |> Enum.each(fn cite ->
          IO.puts("  • #{truncate(cite.citation_text, 70)}")
        end)
      end
    else
      IO.puts(IO.ANSI.red() <> "No card selected" <> IO.ANSI.reset())
    end
  end

  defp render_footer_detail do
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> String.duplicate("-", 80) <> IO.ANSI.reset())
    IO.puts("  e: Edit  Esc or b: Back to list  q: Quit")
    IO.puts(IO.ANSI.yellow() <> "  (All commands work instantly!)" <> IO.ANSI.reset())
  end

  defp render_card_edit(state) do
    card = state.current_card

    if card do
      IO.puts(IO.ANSI.bright() <> "Editing Card: #{card.id}" <> IO.ANSI.reset())
      IO.puts("")
      IO.puts("1. Title: #{truncate(card.title, 60)}")
      IO.puts("2. Content Text: #{truncate(card.content_text || "", 60)}")
      IO.puts("3. Definition Text: #{truncate(card.definition_text || "", 60)}")
      IO.puts("")

      if state.edit_field do
        IO.puts(IO.ANSI.yellow() <> "Editing #{state.edit_field}:" <> IO.ANSI.reset())
        IO.puts(state.edit_buffer)
      else
        IO.puts("Select a field to edit (1-3)")
      end
    end
  end

  defp render_footer_edit do
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> String.duplicate("-", 80) <> IO.ANSI.reset())
    IO.puts("  1-3: Select field  s: Save  Esc or c: Cancel  b: Back")
    IO.puts(IO.ANSI.yellow() <> "  (Type command and press Enter)" <> IO.ANSI.reset())
  end

  defp render_search(state) do
    IO.puts(IO.ANSI.bright() <> "Search Cards" <> IO.ANSI.reset())
    IO.puts("")
    IO.puts("Query: #{state.search_query}_")
    IO.puts("")

    if state.search_query != "" and length(state.cards) > 0 do
      IO.puts("Results (#{length(state.cards)}):")
      IO.puts("")

      state.cards
      |> Enum.take(10)
      |> Enum.with_index()
      |> Enum.each(fn {card, index} ->
        prefix = if index == state.selected_index, do: "► ", else: "  "
        ref_level = format_ref_level(card)
        IO.puts("#{prefix}#{card.id} - #{truncate(card.title, 60)}#{ref_level}")
      end)
    end
  end

  defp render_footer_search do
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> String.duplicate("-", 80) <> IO.ANSI.reset())
    IO.puts("  Type to search  ↑/↓: Navigate  Enter: View  Esc or b: Back to card list  q: Quit")
    IO.puts(IO.ANSI.yellow() <> "  (Type instantly, use arrows to navigate, Backspace to delete)" <> IO.ANSI.reset())
  end

  defp render_jump(state) do
    IO.puts(IO.ANSI.bright() <> "Jump to Card" <> IO.ANSI.reset())
    IO.puts("")
    IO.puts("Card Number: #{state.jump_buffer}_")
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> "Enter card number (e.g., 1924, C1924, C01924)" <> IO.ANSI.reset())
  end

  defp render_footer_jump do
    IO.puts("")
    IO.puts(IO.ANSI.cyan() <> String.duplicate("-", 80) <> IO.ANSI.reset())
    IO.puts("  Type card number  Enter: Jump to card  Esc or b: Back to card list")
    IO.puts(IO.ANSI.yellow() <> "  (Type instantly, Backspace to delete)" <> IO.ANSI.reset())
  end

  defp get_input(input_device) do
    # Show a visible prompt
    IO.write(IO.ANSI.yellow() <> "\nCommand> " <> IO.ANSI.reset())

    # Read character-by-character from TTY for instant response
    result = read_char_input(input_device)
    IO.puts("\nDEBUG: Returning command: #{inspect(result)}")
    :timer.sleep(500)  # Brief pause to see the debug message
    result
  end

  # Read a single character from standard_io
  defp get_char(:standard_io) do
    case :io.get_chars(:standard_io, "", 1) do
      :eof -> :eof
      {:error, _reason} -> :error
      char -> char
    end
  end

  # Read input character-by-character and handle escape sequences
  defp read_char_input(input_device) do
    char = get_char(input_device)

    case char do
      :eof -> :quit
      :error -> :quit

      # Escape sequence (arrow keys, etc.)
      "\e" ->
        # Peek at next character to see if it's an escape sequence or standalone Esc
        case :io.get_chars(input_device, "", 1) do
          "[" ->
            case get_char(input_device) do
              "A" -> :up
              "B" -> :down
              "C" -> :next_page  # Right arrow = next page
              "D" -> :prev_page  # Left arrow = prev page
              _other -> read_char_input(input_device)  # Unknown sequence, try again
            end
          # If no character follows immediately, treat as standalone Esc key
          :eof -> :escape
          {:error, _} -> :escape
          _other -> :escape  # Standalone Esc key
        end

      # Regular commands
      "q" -> :quit
      "j" -> :down
      "k" -> :up
      "n" -> :next_page
      "p" -> :prev_page
      "/" -> :search
      "g" -> :jump
      "b" -> :back
      "e" -> :edit
      "s" -> :save
      "c" -> :cancel
      "1" -> {:select_field, 1}
      "2" -> {:select_field, 2}
      "3" -> {:select_field, 3}
      "\n" -> :enter
      "\r" -> :enter

      # For text input (search mode), we need to collect a string
      # This will be handled specially in search mode
      char -> {:char, char}
    end
  end



  defp truncate(text, max_length) do
    if String.length(text) > max_length do
      String.slice(text, 0, max_length - 3) <> "..."
    else
      text
    end
  end
end
