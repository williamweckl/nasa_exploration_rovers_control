defmodule FakeSystem do
  @moduledoc """
  This module is a Elixir's System mock to help testing the system.
  """

  @doc false
  def cmd(_command, _args, _opts), do: :ok

  @doc false
  def halt(_code), do: :ok

end
