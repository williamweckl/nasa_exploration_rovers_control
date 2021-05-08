defmodule NasaExplorationRoversControl.Interactors.MoveExplorationRover do
  @moduledoc """
  Use case responsible for move an exploration rover.

  Do not call this module directly, use always the NasaExplorationRoversControl bounded context.
  """

  alias NasaExplorationRoversControl.ExplorationRover

  def perform(%ExplorationRover{position: current_position, direction: current_direction} = exploration_rover) do
    {x, y} = current_position

    new_position = case current_direction do
      "N" -> {x, y + 1}
      "S" -> {x, y - 1}
      "W" -> {x - 1, y}
      "E" -> {x + 1, y}
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_position(exploration_rover, new_position)
  end

end
