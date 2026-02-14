defmodule Mix.Tasks.Tui do
  @moduledoc """
  Runs the Synergetics Dictionary TUI.

  ## Usage

      mix tui

  """
  use Mix.Task

  @shortdoc "Runs the Synergetics Dictionary TUI"

  @impl Mix.Task
  def run(_args) do
    # Start the application to ensure dependencies are loaded
    Mix.Task.run("app.start")
    
    # Run the TUI
    SynergeticsTui.TUI.start()
  end
end

