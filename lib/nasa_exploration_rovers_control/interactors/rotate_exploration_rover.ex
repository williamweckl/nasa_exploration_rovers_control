defmodule NASAExplorationRoversControl.Interactors.RotateExplorationRover do
  @moduledoc """
  Use case responsible for rotate an exploration rover.

  Do not call this module directly, use always the NASAExplorationRoversControl bounded context.
  """

  alias NASAExplorationRoversControl.ExplorationRover

  @doc false
  def perform(%ExplorationRover{direction: current_direction} = exploration_rover, "L") do
    new_direction = case current_direction do
      "N" -> "W"
      "S" -> "E"
      "W" -> "S"
      "E" -> "N"
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_direction(exploration_rover, new_direction)
  end
  def perform(%ExplorationRover{direction: current_direction} = exploration_rover, "R") do
    new_direction = case current_direction do
      "N" -> "E"
      "S" -> "W"
      "W" -> "N"
      "E" -> "S"
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_direction(exploration_rover, new_direction)
  end
  def perform(_exploration_rover, _direction), do: {:error, "Invalid direction."}

end
