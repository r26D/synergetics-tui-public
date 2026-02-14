defmodule SynergeticsTui do
  @moduledoc """
  Synergetics Dictionary Terminal User Interface.

  A TUI for browsing and editing cards from the Synergetics Dictionary database.
  """

  @doc """
  Starts the TUI application.
  """
  def main(_args \\ []) do
    SynergeticsTui.TUI.start()
  end
end
