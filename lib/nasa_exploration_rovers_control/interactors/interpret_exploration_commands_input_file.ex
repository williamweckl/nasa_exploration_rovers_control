defmodule NASAExplorationRoversControl.Interactors.InterpretExplorationCommandsInputFile do
  @moduledoc """
  Use case responsible for interpret exploration commands input file and return a readable map.

  Do not call this module directly, use always the NASAExplorationRoversControl bounded context.
  """

  alias NASAExplorationRoversControl.ExplorationRover

  @doc false
  def perform(file_path) do
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
    |> validate_exploration_rover_initial_position_comparing_to_others(row_index, exploration_rovers)

    normalized_result = case result do
      {:ok, exploration_rover} -> exploration_rover
      result -> result
    end

    exploration_rovers ++ [normalized_result] # Order is important
  end

  defp validate_exploration_rovers_is_not_an_empty_list(%{exploration_rovers: []}) do
    {:error, "Exploration rovers list is empty."}
  end
  defp validate_exploration_rovers_is_not_an_empty_list(%{exploration_rovers: _exploration_rovers} = input), do: input
  defp validate_exploration_rovers_is_not_an_empty_list({:error, _error_message} = error_result), do: error_result

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
    {:ok, %{position: normalize_coordinates({x, y}), direction: direction}}
  end
  defp parse_exploration_rover_position_and_direction(_), do: {:error, "Position or direction are invalid."}

  defp parse_exploration_rover_commands_string({:ok, input}, commands_string) when is_binary(commands_string) do
    commands = commands_string |> String.codepoints
    input = input |> Map.put(:commands, commands)

    {:ok, input}
  end
  defp parse_exploration_rover_commands_string({:ok, _}, nil), do: {:error, "Commands list must not be empty."}
  defp parse_exploration_rover_commands_string({:error, _error_message} = error_result, _commands_string) do
    error_result
  end

  defp initialize_exploration_rover({:ok, %{position: position, direction: direction} = input}) do
    {:ok, exploration_rover} = ExplorationRover.new(position: position, direction: direction)

    {:ok, %{exploration_rover: exploration_rover, input: input}}
  end
  defp initialize_exploration_rover({:error, _error_message} = error_result), do: error_result

  defp give_commands_to_exploration_rover(
    {:ok, %{exploration_rover: exploration_rover, input: %{commands: commands}}}
  ) do
    exploration_rover |> ExplorationRover.give_commands(commands)
  end
  defp give_commands_to_exploration_rover({:error, _error_message} = error_result), do: error_result

  defp validate_exploration_rover_initial_position_comparing_to_others(
    {:ok, %ExplorationRover{position: position} = exploration_rover}, row_index, exploration_rovers
  ) do
    other_exploration_rover_with_the_same_position_index = exploration_rovers
      |> Enum.with_index()
      |> Enum.find_index(fn {other_exploration_rover, index} ->
        case other_exploration_rover do
          %ExplorationRover{} -> other_exploration_rover.position == position && index != row_index
          _ -> false
        end
      end)

    if other_exploration_rover_with_the_same_position_index do
      {:error, "There is something wrong with the initial position of this rover. It is the same as Rover #{other_exploration_rover_with_the_same_position_index + 1} and it is probably wrong as the system prevents rover collisions. Please fix it and try again."}
    else
      {:ok, exploration_rover}
    end
  end
  defp validate_exploration_rover_initial_position_comparing_to_others(
    {:error, _error_message} = error_result, _row_index, _exploration_rovers
  ), do: error_result

end
