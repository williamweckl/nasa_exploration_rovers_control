defmodule FakeFile do
  @moduledoc """
  This module is a Elixir's File mock to help testing the system.
  """

  @doc false
  def mkdir_p!(_path), do: :ok

  @doc false
  def write!(_path, _content), do: :ok

end
