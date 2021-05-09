defmodule NASAExplorationRoversControl.Interactors.ExecuteExplorationRoverCommands do
  @moduledoc """
  Use case responsible for execute an exploration rover given commands.

  Do not call this module directly, use always the NASAExplorationRoversControl bounded context.
  """

  alias NASAExplorationRoversControl.ExplorationRover

  def perform(%ExplorationRover{commands: commands} = exploration_rover) when length(commands) > 0 do
    result = Enum.reduce(commands, {:ok, exploration_rover}, fn command, acc ->
      case acc do
        {:ok, exploration_rover_to_be_changed} ->
          execute_single_exploration_rover_command(exploration_rover_to_be_changed, command)
        _ ->
          acc
      end
    end)

    case result do
      {:ok, exploration_rover} ->
        ExplorationRover.clear_commands(exploration_rover)
      {:error, "Invalid position. Coordinates must not be negative."} ->
        {
          :error,
          "The system prevented the exploration rover from leaving the ground. " <>
          "Check the commands and try again. The exploration rover was kept in the initial position and direction."
        }
      _ ->
        result
    end
  end
  def perform(_), do: {:error, "Exploration rover has not commands to be executed."}

  defp execute_single_exploration_rover_command(exploration_rover_to_be_changed, command) do
    case command do
      "M" -> NASAExplorationRoversControl.move_exploration_rover(exploration_rover_to_be_changed)
      "L" -> NASAExplorationRoversControl.rotate_exploration_rover(exploration_rover_to_be_changed, "L")
      "R" -> NASAExplorationRoversControl.rotate_exploration_rover(exploration_rover_to_be_changed, "R")
      _ -> raise "Exploration rover has an invalid command: #{command}"
    end
  end

end
