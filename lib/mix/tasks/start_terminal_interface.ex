defmodule Mix.Tasks.StartTerminalInterface do
  @moduledoc """
  Automated task to start the terminal interface that is a way that users can interact with the system business logic and have the chace to make a difference to the world by exploring another celestial bodies.

  This task does not requires any inputs, all the inputs are asked after the first run and user will be followed through some steps.

  To run this task type the command `mix start_terminal_interface` in your command prompt.

  See `lib/nasa_exploration_rovers_control_terminal_interface.ex` for more info.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    NASAExplorationRoversControlTerminalInterface.start()
  end

end
