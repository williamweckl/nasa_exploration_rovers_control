defmodule NASAExplorationRoversControl.CollisionChecker do
  @moduledoc """
  Exploration rovers collision checker.
  """

  alias NASAExplorationRoversControl.ExplorationRover

  @doc """
  Checks for collisions using exploration rovers positions.

  Returns the list index from collided rover.

  ## Examples

      iex> all_exploration_rovers = [%#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}, %#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}]
      ...> fetch_collided_rover_index!(%#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}, 1, all_exploration_rovers)
      0

      iex> all_exploration_rovers = [%#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}, %#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}]
      ...> fetch_collided_rover_index!(%#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}, 0, all_exploration_rovers)
      1

      iex> all_exploration_rovers = [%#{ExplorationRover}{position: {0, 3}, direction: "N", commands: []}, %#{ExplorationRover}{position: {3, 3}, direction: "N", commands: []}, %#{ExplorationRover}{position: {3, 3}, direction: "N", commands: []}]
      ...> fetch_collided_rover_index!(%#{ExplorationRover}{position: {3, 3}, direction: "N", commands: []}, 2, all_exploration_rovers)
      1

  """
  def fetch_collided_rover_index!(%ExplorationRover{position: position}, rover_index, all_exploration_rovers) do
    all_exploration_rovers
      |> Enum.with_index()
      |> Enum.find_index(fn {exploration_rover, index} ->
        case exploration_rover do
          %ExplorationRover{} -> exploration_rover.position == position && index != rover_index
          _ -> false
        end
      end)
  end

end
