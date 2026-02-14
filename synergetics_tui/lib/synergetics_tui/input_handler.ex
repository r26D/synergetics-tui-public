defmodule SynergeticsTui.InputHandler do
  @moduledoc """
  Handles input events and updates state accordingly.
  """

  alias SynergeticsTui.{Database, TUI.State}

  @page_size 20

  def handle_input(%State{mode: :list} = state, input) do
    case input do
      :down ->
        new_index = min(state.selected_index + 1, length(state.cards) - 1)
        %{state | selected_index: new_index}
      
      :up ->
        new_index = max(state.selected_index - 1, 0)
        %{state | selected_index: new_index}
      
      :next_page ->
        new_offset = min(state.offset + @page_size, state.total_count - @page_size)
        cards = Database.list_cards(state.conn, limit: @page_size, offset: new_offset)
        %{state | offset: new_offset, cards: cards, selected_index: 0}
      
      :prev_page ->
        new_offset = max(state.offset - @page_size, 0)
        cards = Database.list_cards(state.conn, limit: @page_size, offset: new_offset)
        %{state | offset: new_offset, cards: cards, selected_index: 0}
      
      :enter ->
        if state.selected_index < length(state.cards) do
          card = Enum.at(state.cards, state.selected_index)
          full_card = Database.get_card(state.conn, card.id)
          %{state | mode: :detail, current_card: full_card}
        else
          state
        end
      
      :search ->
        %{state | mode: :search, search_query: "", selected_index: 0}
      
      _ ->
        state
    end
  end

  def handle_input(%State{mode: :detail} = state, input) do
    case input do
      :back ->
        %{state | mode: :list, current_card: nil}
      
      :edit ->
        %{state | mode: :edit, edit_field: nil, edit_buffer: ""}
      
      _ ->
        state
    end
  end

  def handle_input(%State{mode: :edit} = state, input) do
    case input do
      {:select_field, 1} ->
        %{state | edit_field: :title, edit_buffer: state.current_card.title}

      {:select_field, 2} ->
        %{state | edit_field: :content_text, edit_buffer: state.current_card.content_text || ""}

      {:select_field, 3} ->
        %{state | edit_field: :definition_text, edit_buffer: state.current_card.definition_text || ""}

      :save ->
        if state.edit_field do
          case Database.update_card(state.conn, state.current_card.id, %{state.edit_field => state.edit_buffer}) do
            :ok ->
              updated_card = Database.get_card(state.conn, state.current_card.id)
              %{state |
                mode: :detail,
                current_card: updated_card,
                edit_field: nil,
                edit_buffer: "",
                message: "Card updated successfully"
              }

            {:error, reason} ->
              %{state | message: "Error updating card: #{inspect(reason)}"}
          end
        else
          %{state | message: "No field selected to save"}
        end

      :cancel ->
        %{state | mode: :detail, edit_field: nil, edit_buffer: ""}

      :back ->
        %{state | mode: :detail, edit_field: nil, edit_buffer: ""}

      # Handle character input for editing
      {:char, char} ->
        if state.edit_field do
          # Handle backspace/delete
          new_buffer = if char == "\d" or char == "\x7F" do
            String.slice(state.edit_buffer, 0..-2//1)
          else
            state.edit_buffer <> char
          end
          %{state | edit_buffer: new_buffer}
        else
          state
        end

      # Legacy support for {:text, text}
      {:text, text} ->
        if state.edit_field do
          %{state | edit_buffer: state.edit_buffer <> text}
        else
          state
        end

      _ ->
        state
    end
  end

  def handle_input(%State{mode: :search} = state, input) do
    case input do
      # Handle character input for search
      {:char, char} ->
        # Handle backspace/delete
        new_query = if char == "\d" or char == "\x7F" do
          String.slice(state.search_query, 0..-2//1)
        else
          state.search_query <> char
        end

        cards = if String.length(new_query) >= 2 do
          Database.search_cards(state.conn, new_query, limit: 50)
        else
          []
        end
        %{state | search_query: new_query, cards: cards, selected_index: 0}

      # Legacy support for {:text, text}
      {:text, text} ->
        new_query = state.search_query <> text
        cards = if String.length(new_query) >= 2 do
          Database.search_cards(state.conn, new_query, limit: 50)
        else
          []
        end
        %{state | search_query: new_query, cards: cards, selected_index: 0}

      :back ->
        cards = Database.list_cards(state.conn, limit: @page_size, offset: state.offset)
        %{state | mode: :list, search_query: "", cards: cards, selected_index: 0}

      :enter ->
        if state.selected_index < length(state.cards) do
          card = Enum.at(state.cards, state.selected_index)
          full_card = Database.get_card(state.conn, card.id)
          %{state | mode: :detail, current_card: full_card}
        else
          state
        end

      :down ->
        new_index = min(state.selected_index + 1, length(state.cards) - 1)
        %{state | selected_index: new_index}

      :up ->
        new_index = max(state.selected_index - 1, 0)
        %{state | selected_index: new_index}

      _ ->
        state
    end
  end
end

