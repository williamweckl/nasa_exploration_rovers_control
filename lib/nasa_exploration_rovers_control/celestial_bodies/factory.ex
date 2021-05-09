defmodule NASAExplorationRoversControl.CelestialBodies.Factory do
  @moduledoc """
  Factory responsible to interact with inputs and return the Celestial Body module accordingly.
  """

  alias NASAExplorationRoversControl.CelestialBodies

  @doc """
  Use the commands instructions from file to interact with the exploration rovers.
  The output is a map containing the ground size and all the exploration rovers with their new positions and directions.

  ## Examples

      iex> get_celestial_body_module("mars")
      {:ok, NASAExplorationRoversControl.CelestialBodies.Mars}

      iex> get_celestial_body_module("moon")
      {:error, "Celestial Body is not mapped to be explored yet."}

      iex> get_celestial_body_module("saturn")
      {:error, "Celestial Body is not mapped to be explored yet."}

  """
  def get_celestial_body_module("mars") do
    {:ok, CelestialBodies.Mars}
  end
  def get_celestial_body_module(_), do: {:error, "Celestial Body is not mapped to be explored yet."}

end
