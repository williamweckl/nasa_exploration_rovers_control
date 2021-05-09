defmodule Mix.Tasks.StartTerminalInterfaceTest do
  use ExUnit.Case

  import Mock

  describe "run/1" do
    test "calls terminal interface start" do
      with_mock(
        NasaExplorationRoversControlTerminalInterface,
        [
          start: fn() -> :ok end
        ]
      ) do
        assert Mix.Tasks.StartTerminalInterface.run([]) == :ok

        assert_called NasaExplorationRoversControlTerminalInterface.start()
      end
    end
  end

end
