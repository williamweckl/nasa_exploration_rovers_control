defmodule FakeIO do
  @moduledoc """
  This module is a Elixir's IO mock to help testing the system.
  """

  @doc false
  def puts(_message), do: :ok

  @doc false
  def write(_message), do: :ok

  @doc false
  def read(:stdio, :line), do: :ok

end
