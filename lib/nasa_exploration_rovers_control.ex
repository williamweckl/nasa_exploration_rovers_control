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
    result = file_path
    |> File.read!()
    |> String.split("\n")
    |> split_file_content_into_ground_size_and_exploration_rovers()
    |> parse_ground_size()
    |> parse_exploration_rovers()
    |> validate_exploration_rovers_is_not_an_empty_list()

    case result do
      {:error, _error} -> result
      _result -> {:ok, result}
    end
  rescue
    File.Error ->
      {:error, "File path is invalid."}
  end

  defp split_file_content_into_ground_size_and_exploration_rovers(file_content) do
    [ground_size | tail] = file_content
    %{ground_size: ground_size, exploration_rovers: tail}
  end

  defp parse_ground_size(%{ground_size: ground_size} = input) when is_binary(ground_size) do
    input
      |> Map.put(:ground_size, ground_size |> String.split(" "))
      |> parse_ground_size()
  end
  defp parse_ground_size(%{ground_size: ground_size} = input) when is_list(ground_size) and length(ground_size) == 2 do
    [ground_size_x, ground_size_y] = ground_size
    ground_size = normalize_coordinates({ground_size_x, ground_size_y})

    input
      |> Map.put(:ground_size, ground_size)
  end
  defp parse_ground_size(_), do: {:error, "Ground size is invalid."}

  defp parse_exploration_rovers(%{exploration_rovers: raw_exploration_rovers} = input) do
    exploration_rovers = raw_exploration_rovers
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, index}, acc ->
        if is_exploration_rover_position_row?(index) do
          row
          |> parse_exploration_rover_row(index, raw_exploration_rovers, acc)
        else
          # Skip commands rows that are appended to exploration rovers
          acc
        end
      end)

    input
    |> Map.put(:exploration_rovers, exploration_rovers)
  end
  defp parse_exploration_rovers(error_result), do: error_result

  defp parse_exploration_rover_row(row, row_index, raw_exploration_rovers, exploration_rovers) do
    next_line = raw_exploration_rovers |> Enum.at(row_index + 1)

    result = row
    |> parse_exploration_rover_position_and_direction()
    |> parse_exploration_rover_commands_string(next_line)
    |> initialize_exploration_rover()
    |> give_commands_to_exploration_rover()

    normalized_result = case result do
      {:ok, exploration_rover} -> exploration_rover
      result -> result
    end

    exploration_rovers ++ [normalized_result] # Order is important
  end

  defp validate_exploration_rovers_is_not_an_empty_list(%{exploration_rovers: exploration_rovers})
    when length(exploration_rovers) == 0 do
    {:error, "Exploration rovers list is empty."}
  end
  defp validate_exploration_rovers_is_not_an_empty_list(%{exploration_rovers: _exploration_rovers} = input), do: input
  defp validate_exploration_rovers_is_not_an_empty_list(error_result), do: error_result

  defp is_exploration_rover_position_row?(row_index) do
    # The even rows defines the exploration rover positions
    rem(row_index, 2) == 0
  end

  defp normalize_coordinates({x, y}) do
    {String.to_integer(x), String.to_integer(y)}
  end

  defp parse_exploration_rover_position_and_direction(position_and_direction) when is_binary(position_and_direction) do
    position_and_direction |> String.split(" ") |> parse_exploration_rover_position_and_direction()
  end
  defp parse_exploration_rover_position_and_direction(position_and_direction)
    when is_list(position_and_direction) and length(position_and_direction) == 3 do
    [x, y, direction] = position_and_direction
    {:ok, %{position: normalize_coordinates({x,y}), direction: direction}}
  end
  defp parse_exploration_rover_position_and_direction(_), do: {:error, "Position or direction are invalid."}

  defp parse_exploration_rover_commands_string({:ok, input}, commands_string) when is_binary(commands_string) do
    commands = commands_string |> String.codepoints
    input = input |> Map.put(:commands, commands)

    {:ok, input}
  end
  defp parse_exploration_rover_commands_string({:ok, _}, nil), do: {:error, "Commands list must not be empty."}
  defp parse_exploration_rover_commands_string({:error, _} = result, _commands_string), do: result

  defp initialize_exploration_rover({:ok, %{position: position, direction: direction} = input}) do
    {:ok, exploration_rover} = ExplorationRover.new(position: position, direction: direction)

    {:ok, %{exploration_rover: exploration_rover, input: input}}
  end
  defp initialize_exploration_rover(result), do: result

  defp give_commands_to_exploration_rover(
    {:ok, %{exploration_rover: exploration_rover, input: %{commands: commands}}}
  ) do
    exploration_rover |> ExplorationRover.give_commands(commands)
  end
  defp give_commands_to_exploration_rover(result), do: result

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
      {:error, "Invalid position. Coordinates must not be negative."}

      iex> execute_exploration_rover_commands(%#{ExplorationRover}{position: {0,0}, direction: "W", commands: ["I"]})
      ** (RuntimeError) Exploration rover has an invalid command: I
  """
  def execute_exploration_rover_commands(
    %ExplorationRover{commands: commands} = exploration_rover
  ) when length(commands) > 0 do
    result = Enum.reduce(commands, {:ok, exploration_rover}, fn command, acc ->
      case acc do
        {:ok, exploration_rover_to_be_changed} ->
          case command do
            "M" -> move_exploration_rover(exploration_rover_to_be_changed)
            "L" -> rotate_exploration_rover(exploration_rover_to_be_changed, "L")
            "R" -> rotate_exploration_rover(exploration_rover_to_be_changed, "R")
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
  def execute_exploration_rover_commands(_), do: {:error, "Exploration rover has not commands to be executed."}

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

      iex> move_exploration_rover(%#{ExplorationRover}{position: {0,0}, direction: "I"})
      ** (RuntimeError) Exploration rover has an invalid direction
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
      _ -> raise "Exploration rover has an invalid direction"
    end

    ExplorationRover.change_position(exploration_rover, new_position)
  end

end
