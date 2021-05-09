defmodule NasaExplorationRoversControl.CelestialBodies.Mars do
  @moduledoc """
  Module representing Mars Celestial Body.
  """

  @average_time_for_exploration_rovers_to_receive_commands "8 minutes"

  @doc """
  Returns the time for Exploration Rovers to receive commands.

  ## Examples

      iex> average_time_for_exploration_rovers_to_receive_commands()
      "8 minutes"

  """
  def average_time_for_exploration_rovers_to_receive_commands do
    @average_time_for_exploration_rovers_to_receive_commands
  end

  @doc """
  Validates if the given instructions are valid for Mars exploration.

  If it is valid, returns the current input. If not, returns an error according to the validation not fullfiled.

  If the input is an error previously given, the output will be the same given error.

  ## Examples

      iex> validate({:ok, %{ground_size: {10, 2}, exploration_rovers: []}})
      {:ok, %{ground_size: {10, 2}, exploration_rovers: []}}

      iex> validate({:ok, %{ground_size: {5, 5}, exploration_rovers: []}})
      {:error, "The terrain of mars is rectangular and the value entered is a square. Please check your commands."}

      iex> validate({:error, "Some previous error."})
      {:error, "Some previous error."}

  """
  def validate({:ok, %{ground_size: {x, y}}}) when x == y do
    {:error, "The terrain of mars is rectangular and the value entered is a square. Please check your commands."}
  end
  def validate({:ok, %{ground_size: {_x, _y}}} = input), do: input
  def validate({:error, _error_message} = result), do: result

end
