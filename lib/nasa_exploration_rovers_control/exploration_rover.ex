defmodule NasaExplorationRoversControl.ExplorationRover do
  @moduledoc """
  Exploration Rover entity, it represents a real exploration rover that is exploring another planet.

  It has three attributes:
  - position (required): A tuble with x and y axis.
  - direction (required): A direction according to the Wind Rose Compass (in English) represented by a single character string. Valid values are N, S, W, E.
  - commands: A list of commands to be performed by rover. Valid values for each command in the list are L (left), R (right) or M (move).

  ## Examples

      iex> %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}

      iex> %NasaExplorationRoversControl.ExplorationRover{position: {3,2}, direction: "S"}
      %NasaExplorationRoversControl.ExplorationRover{position: {3,2}, direction: "S"}

      iex> %NasaExplorationRoversControl.ExplorationRover{position: {6,6}, direction: "W"}
      %NasaExplorationRoversControl.ExplorationRover{position: {6,6}, direction: "W"}

      iex> %NasaExplorationRoversControl.ExplorationRover{position: {3,0}, direction: "E"}
      %NasaExplorationRoversControl.ExplorationRover{position: {3,0}, direction: "E"}
  """

  alias NasaExplorationRoversControl.ExplorationRover

  @enforce_keys [:position, :direction]
  defstruct position: {0, 0}, direction: "N", commands: []

  @type t() :: %__MODULE__{
    position: Tuple.t(),
    direction: String.t(),
    commands: List.t()
  }

  @doc """
  Returns a new struct for given position and direction.
  It also validates position and direction fields and raise when something is not right.

  ## Examples

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {10,3}, direction: "W")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {10,3}, direction: "W"}}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {3,5}, direction: "S")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {3,5}, direction: "S"}}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {-1,0}, direction: "E")
      {:error, "Invalid position. Coordinates must not be negative."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,-1}, direction: "E")
      {:error, "Invalid position. Coordinates must not be negative."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: "string", direction: "E")
      {:error, "Invalid position. Must be a tuple."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: 123, direction: "N")
      {:error, "Invalid position. Must be a tuple."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: [], direction: "N")
      {:error, "Invalid position. Must be a tuple."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: %{}, direction: "N")
      {:error, "Invalid position. Must be a tuple."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "invalid")
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "I")
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "P")
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: 123)
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: [])
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: {})
      {:error, "Invalid direction. Must be N,S,W or E."}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: %{})
      {:error, "Invalid direction. Must be N,S,W or E."}

  """
  def new(position: position, direction: direction) do
    {:ok, %ExplorationRover{position: position, direction: direction}}
    |> validate_position()
    |> validate_direction()
  end

  defp validate_position({:ok, %ExplorationRover{position: position} = exploration_rover}) when is_tuple(position) do
    {x, y} = position
    if x < 0 || y < 0 do
      {:error, "Invalid position. Coordinates must not be negative."}
    else
      {:ok, exploration_rover}
    end
  end
  defp validate_position(_result), do: {:error, "Invalid position. Must be a tuple."}

  defp validate_direction({:error, error}), do: {:error, error}
  defp validate_direction({:ok, %ExplorationRover{direction: direction} = exploration_rover})
    when direction in ["N", "S", "W", "E"] do
    {:ok, exploration_rover}
  end
  defp validate_direction(_result), do: {:error, "Invalid direction. Must be N,S,W or E."}

  @doc """
  Adds commands to an existing exploration rover.
  Each command will be validated to match a valid command that can be L (left), R (right) or M (move).

  ## Examples

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands(["L"])
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: ["L"]}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands(["L", "L", "R"])
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: ["L", "L", "R"]}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands([])
      {:error, "Commands list must not be empty."}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands("string")
      {:error, "Commands must be a list."}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands(["I"])
      {:error, "Command `I` is invalid. Must be L, R or M."}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.give_commands(["L","M","P"])
      {:error, "Command `P` is invalid. Must be L, R or M."}
  """
  def give_commands(exploration_rover, commands) do
    {:ok, %ExplorationRover{exploration_rover | commands: commands}}
    |> validate_commands()
  end

  @doc """
  Clears an existing exploration rover given commands.

  ## Examples

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: ["L"]}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.clear_commands()
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: []}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: ["L","M","R"]}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.clear_commands()
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N", commands: []}}
  """
  def clear_commands(exploration_rover) do
    {:ok, %ExplorationRover{exploration_rover | commands: []}}
  end

  defp validate_commands({:ok, %ExplorationRover{commands: commands} = exploration_rover})
    when is_list(commands) and length(commands) > 0 do
    case validate_each_command(commands) do
      :ok -> {:ok, exploration_rover}
      validation_result -> validation_result
    end
  end
  defp validate_commands({:ok, %ExplorationRover{commands: commands}}) when is_list(commands) do
    {:error, "Commands list must not be empty."}
  end
  defp validate_commands(_result), do: {:error, "Commands must be a list."}

  defp validate_each_command(commands) do
    invalid_command = Enum.find(commands, fn (command) -> !valid_command?(command) end)
    if invalid_command do
      {:error, "Command `#{invalid_command}` is invalid. Must be L, R or M."}
    else
      :ok
    end
  end

  defp valid_command?(command) when command in ["L", "R", "M"], do: true
  defp valid_command?(_command), do: false

  @doc """
  Changes existent exploration rover direction.

  ## Examples

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_direction("W")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "W"}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "S"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_direction("E")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "E"}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "S"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_direction("I")
      {:error, "Invalid direction. Must be N,S,W or E."}

  """
  def change_direction(%ExplorationRover{} = exploration_rover, new_direction) do
    {:ok, %ExplorationRover{exploration_rover | direction: new_direction}}
    |> validate_direction()
  end

  @doc """
  Changes existent exploration rover position.

  ## Examples

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "N"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_position({3,3})
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {3,3}, direction: "N"}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "S"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_position({1,4})
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {1,4}, direction: "S"}}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "S"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_position({-1,4})
      {:error, "Invalid position. Coordinates must not be negative."}

      iex> exploration_rover = %NasaExplorationRoversControl.ExplorationRover{position: {0,0}, direction: "S"}
      ...> exploration_rover |> NasaExplorationRoversControl.ExplorationRover.change_position(123)
      {:error, "Invalid position. Must be a tuple."}

  """
  def change_position(%ExplorationRover{} = exploration_rover, new_position) do
    {:ok, %ExplorationRover{exploration_rover | position: new_position}}
    |> validate_position()
  end

end
