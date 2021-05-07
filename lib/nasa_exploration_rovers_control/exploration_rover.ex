defmodule NasaExplorationRoversControl.ExplorationRover do
  @moduledoc """
  Exploration Rover entity, it represents a real exploration rover that is exploring another planet.

  It has two attributes, both required:
  - position: A tuble with x and y axis.
  - direction: A direction according to the Wind Rose Compass (in English) represented by a single character string. Valid values are N, S, W, E.

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
  defstruct position: {0, 0}, direction: "N"

  @type t() :: %__MODULE__{
    position: Tuple.t(),
    direction: String.t()
  }

  @doc """
  Returns a new struct for given position and direction.
  It also validates position and direction fields and raise when something is not right.

  ## Examples

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {10,3}, direction: "W")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {10,3}, direction: "W"}}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {3,5}, direction: "S")
      {:ok, %NasaExplorationRoversControl.ExplorationRover{position: {3,5}, direction: "S"}}

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
    {:ok, exploration_rover}
  end
  defp validate_position(_exploration_rover), do: {:error, "Invalid position. Must be a tuple."}

  defp validate_direction({:error, error}), do: {:error, error}
  defp validate_direction({:ok, %ExplorationRover{direction: direction} = exploration_rover})
  when direction in ["N", "S", "W", "E"] do
    {:ok, exploration_rover}
  end
  defp validate_direction(_exploration_rover), do: {:error, "Invalid direction. Must be N,S,W or E."}

end
