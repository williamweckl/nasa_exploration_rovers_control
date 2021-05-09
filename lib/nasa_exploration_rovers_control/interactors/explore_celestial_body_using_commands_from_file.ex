defmodule NASAExplorationRoversControl.Interactors.ExploreCelestialBodyUsingCommandsFromFile do
  @moduledoc """
  Use case responsible for use the commands instructions from file to interact with the exploration rovers to explore a Celestial Body.

  Do not call this module directly, use always the NASAExplorationRoversControl bounded context.
  """

  alias NASAExplorationRoversControl.CelestialBodies
  alias NASAExplorationRoversControl.ExplorationRover

  @doc false
  def perform(celestial_body_name, input_file) do
    celestial_body_name
    |> CelestialBodies.Factory.get_celestial_body_module()
    |> do_perform(input_file)
  end

  def do_perform({:error, _error_message} = error_result, _input_file), do: error_result
  def do_perform({:ok, celestial_body_module}, input_file) do
    input_file
    |> NASAExplorationRoversControl.interpret_exploration_commands_input_file()
    |> celestial_body_module.validate()
    |> explore()
  end

  defp explore({:ok, %{ground_size: ground_size, exploration_rovers: exploration_rovers}}) do
    exploration_rovers = exploration_rovers
    |> Enum.map(fn exploration_rover ->
      result = exploration_rover
      |> NASAExplorationRoversControl.execute_exploration_rover_commands()
      |> prevent_exploration_rover_to_leave_the_ground(ground_size)

      case result do
        {:ok, exploration_rover} -> exploration_rover
        result -> result
      end
    end)

    {:ok, %{ground_size: ground_size, exploration_rovers: exploration_rovers}}
  end
  defp explore({:error, _error_message} = error_result), do: error_result

  defp prevent_exploration_rover_to_leave_the_ground(
    {:ok, %ExplorationRover{position: {x, y}}}, {ground_size_x, ground_size_y}
  ) when x > ground_size_x or y > ground_size_y do
    {:error, "The system prevented the exploration rover from leaving the ground. Check the commands and try again. The exploration rover was kept in the initial position and direction."}
  end
  defp prevent_exploration_rover_to_leave_the_ground({:ok, %ExplorationRover{} = exploration_rover}, _ground_size) do
    {:ok, exploration_rover}
  end
  defp prevent_exploration_rover_to_leave_the_ground({:error, _error_message} = error_result, _ground_size) do
    error_result
  end

end
