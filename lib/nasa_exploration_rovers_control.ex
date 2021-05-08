defmodule NasaExplorationRoversControl do
  @moduledoc """
  Bounded context for the NASA Exploration Rovers Control System. This module contains all the system use cases.
  """

  alias NasaExplorationRoversControl.ExplorationRover

  @doc """
  Interpret exploration commands input file, returning a readable map.

  ## Examples

      iex> interpret_exploration_commands_input_file("priv/commands_input_files/mars/exploration_attempt_1_by_kayla_barron_2030_05_08")
      {:ok, %{
        ground_size: {5,5},
        exploration_rovers: [
          %#{ExplorationRover}{position: {1,2}, direction: "N", commands: ["L", "M", "L", "M", "L", "M", "L", "M", "M"]},
          %#{ExplorationRover}{position: {3,3}, direction: "E", commands: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]}
        ]
      }}

      iex> interpret_exploration_commands_input_file("priv/commands_input_files/mars/exploration_attempt_2_by_zena_cardman_2030_05_09")
      {:ok, %{
        ground_size: {3,8},
        exploration_rovers: [
          %#{ExplorationRover}{position: {0,0}, direction: "N", commands: ["M", "M", "M"]},
          %#{ExplorationRover}{position: {3,8}, direction: "N", commands: ["L", "M", "M", "M"]}
        ]
      }}

      iex> interpret_exploration_commands_input_file("invalid")
      {:error, "File path is invalid."}

  """
  def interpret_exploration_commands_input_file(file_path) do
    NasaExplorationRoversControl.Interactors.InterpretExplorationCommandsInputFile.perform(file_path)
  end

  @doc """
  Executes an exploration rover given commands.
  The result of this function will be the exploration rover with new direction and position.

  This function also clears the exploration rover commands, as it has already been executed.

  ## Examples

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {0,0}, direction: "N", commands: ["M"]})
      {:ok, %#{ExplorationRover}{position: {0,1}, direction: "N"}}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {1,2}, direction: "N", commands: ["L", "M", "L", "M", "L", "M", "L", "M", "M"]})
      {:ok, %#{ExplorationRover}{position: {1,3}, direction: "N"}}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {3,3}, direction: "E", commands: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]})
      {:ok, %#{ExplorationRover}{position: {5,1}, direction: "E"}}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {0,0}, direction: "N", commands: []})
      {:error, "Exploration rover has not commands to be executed."}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {0,0}, direction: "W", commands: ["M"]})
      {:error, "The system prevented the exploration rover from leaving the ground. Check the commands and try again. The exploration rover was kept in the initial position and direction."}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {0,0}, direction: "W", commands: ["I"]})
      ** (RuntimeError) Exploration rover has an invalid command: I
  """
  def execute_exploration_rover_commands(%ExplorationRover{} = exploration_rover) do
    NasaExplorationRoversControl.Interactors.ExecuteExplorationRoverCommands.perform(exploration_rover)
  end

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
  def rotate_exploration_rover(%ExplorationRover{} = exploration_rover, direction) do
    NasaExplorationRoversControl.Interactors.RotateExplorationRover.perform(exploration_rover, direction)
  end

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

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "I"})
      ** (RuntimeError) Exploration rover has an invalid direction
  """
  def move_exploration_rover(%ExplorationRover{} = exploration_rover) do
    NasaExplorationRoversControl.Interactors.MoveExplorationRover.perform(exploration_rover)
  end

end
