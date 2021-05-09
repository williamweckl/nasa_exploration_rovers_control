defmodule FakeTimer do
  @moduledoc """
  This module is a Erlang's :timer mock to help testing the system.
  """

  @doc false
  def sleep(_), do: :ok

end
