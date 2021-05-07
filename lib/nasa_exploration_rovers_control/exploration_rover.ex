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
      %NasaExplorationRoversControl.ExplorationRover{position: {10,3}, direction: "W"}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {3,5}, direction: "S")
      %NasaExplorationRoversControl.ExplorationRover{position: {3,5}, direction: "S"}

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: "string", direction: "E")
      ** (RuntimeError) Invalid position

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: 123, direction: "N")
      ** (RuntimeError) Invalid position

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: [], direction: "N")
      ** (RuntimeError) Invalid position

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: %{}, direction: "N")
      ** (RuntimeError) Invalid position

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "invalid")
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "I")
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: "P")
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: 123)
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: [])
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: {})
      ** (RuntimeError) Invalid direction

      iex> NasaExplorationRoversControl.ExplorationRover.new(position: {0,0}, direction: %{})
      ** (RuntimeError) Invalid direction

  """
  def new(position: position, direction: direction) do
    validate_position!(position)
    validate_direction!(direction)

    %ExplorationRover{position: position, direction: direction}
  end

  defp validate_position!(position) when is_tuple(position), do: :ok
  defp validate_position!(_position), do: raise "Invalid position"

  defp validate_direction!(direction) when direction in ["N", "S", "W", "E"], do: :ok
  defp validate_direction!(_direction), do: raise "Invalid direction"

end
