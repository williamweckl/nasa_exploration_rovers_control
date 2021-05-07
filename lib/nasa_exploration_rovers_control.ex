defmodule NasaExplorationRoversControl do
  @moduledoc """
  Bounded context for the NASA Exploration Rovers Control System. This module contains all the system use cases.
  """

  alias NasaExplorationRoversControl.ExplorationRover

  @doc """
  Rotates an exploration rover.
  The result of this function will be the exploration rover with a new direction.

  ## Examples

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "N"}, "L")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "W"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "S"}, "L")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "E"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "W"}, "L")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "S"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "E"}, "L")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "N"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "I"}, "L")
      ** (RuntimeError) Exploration rover has an invalid direction

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "N"}, "R")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "E"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "S"}, "R")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "W"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "W"}, "R")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "N"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "E"}, "R")
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "S"}}

      iex> rotate_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "I"}, "R")
      ** (RuntimeError) Exploration rover has an invalid direction
  """
  def rotate_exploration_rover(%ExplorationRover{direction: current_direction} = exploration_rover, "L") do
    new_direction = case current_direction do
      "N" -> "W"
      "S" -> "E"
      "W" -> "S"
      "E" -> "N"
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_direction(exploration_rover, new_direction)
  end
  def rotate_exploration_rover(%ExplorationRover{direction: current_direction} = exploration_rover, "R") do
    new_direction = case current_direction do
      "N" -> "E"
      "S" -> "W"
      "W" -> "N"
      "E" -> "S"
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_direction(exploration_rover, new_direction)
  end
  def rotate_exploration_rover(_exploration_rover, _direction), do: {:error, "Invalid direction."}

  @doc """
  Moves an exploration rover according to its current direction.
  The result of this function will be the exploration rover with a new position.

  ## Examples

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "N"})
      {:ok, %#{ExplorationRover}{position: {0,1}, direction: "N"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,3}, direction: "N"})
      {:ok, %#{ExplorationRover}{position: {0,4}, direction: "N"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,3}, direction: "S"})
      {:ok, %#{ExplorationRover}{position: {0,2}, direction: "S"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,1}, direction: "S"})
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "S"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {2,0}, direction: "W"})
      {:ok, %#{ExplorationRover}{position: {1,0}, direction: "W"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {1,0}, direction: "W"})
      {:ok, %#{ExplorationRover}{position: {0,0}, direction: "W"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {3,0}, direction: "E"})
      {:ok, %#{ExplorationRover}{position: {4,0}, direction: "E"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "E"})
      {:ok, %#{ExplorationRover}{position: {1,0}, direction: "E"}}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "S"})
      {:error, "Invalid position. Coordinates must not be negative."}

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "W"})
      {:error, "Invalid position. Coordinates must not be negative."}
  """
  def move_exploration_rover(
    %ExplorationRover{position: current_position, direction: current_direction} = exploration_rover
  ) do
    {x, y} = current_position

    new_position = case current_direction do
      "N" -> {x, y + 1}
      "S" -> {x, y - 1}
      "W" -> {x - 1, y}
      "E" -> {x + 1, y}
      _ -> raise "Exploration rover has an invalid direction" # TODO: FALTOU ESSE TESTE
    end

    ExplorationRover.change_position(exploration_rover, new_position)
  end

end
