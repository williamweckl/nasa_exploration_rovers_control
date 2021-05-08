defmodule NasaExplorationRoversControl.Interactors.ExecuteExplorationRoverCommands do
  @moduledoc """
  Use case responsible for execute an exploration rover given commands.

  Do not call this module directly, use always the NasaExplorationRoversControl bounded context.
  """

  alias NasaExplorationRoversControl.ExplorationRover

  def perform(%ExplorationRover{commands: commands} = exploration_rover) when length(commands) > 0 do
    result = Enum.reduce(commands, {:ok, exploration_rover}, fn command, acc ->
      case acc do
        {:ok, exploration_rover_to_be_changed} ->
          case command do
            "M" -> NasaExplorationRoversControl.move_exploration_rover(exploration_rover_to_be_changed)
            "L" -> NasaExplorationRoversControl.rotate_exploration_rover(exploration_rover_to_be_changed, "L")
            "R" -> NasaExplorationRoversControl.rotate_exploration_rover(exploration_rover_to_be_changed, "R")
            _ -> raise "Exploration rover has an invalid command: #{command}"
          end
        _ -> acc
      end
    end)

    case result do
      {:ok, exploration_rover} ->
        ExplorationRover.clear_commands(exploration_rover)
      _ ->
        result
    end
  end
  def perform(_), do: {:error, "Exploration rover has not commands to be executed."}

end
