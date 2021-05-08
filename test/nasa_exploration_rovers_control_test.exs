defmodule NasaExplorationRoversControlTest do
  use ExUnit.Case
  doctest NasaExplorationRoversControl, import: true

  import Mock
  alias NasaExplorationRoversControl.ExplorationRover
  alias NasaExplorationRoversControl.Interactors

  describe "interpret_exploration_commands_input_file/1" do
    test "calls the right interactor" do
      with_mock(
        Interactors.InterpretExplorationCommandsInputFile,
        [
          perform: fn(_input_file) -> {:ok, %{}} end
        ]
      ) do
        input_file = "fake input file"
        assert NasaExplorationRoversControl.interpret_exploration_commands_input_file(input_file) == {:ok, %{}}

        assert_called Interactors.InterpretExplorationCommandsInputFile.perform(input_file)
      end
    end
  end

  describe "execute_exploration_rover_commands/1" do
    test "calls the right interactor" do
      with_mock(
        Interactors.ExecuteExplorationRoverCommands,
        [
          perform: fn(_exploration_rover) -> {:ok, %{}} end
        ]
      ) do
        exploration_rover = %ExplorationRover{position: {0,0}, direction: "N", commands: ["M"]}
        assert NasaExplorationRoversControl.execute_exploration_rover_commands(exploration_rover) == {:ok, %{}}

        assert_called Interactors.ExecuteExplorationRoverCommands.perform(exploration_rover)
      end
    end
  end

  describe "rotate_exploration_rover/2" do
    test "calls the right interactor" do
      with_mock(
        Interactors.RotateExplorationRover,
        [
          perform: fn(_exploration_rover, _direction) -> {:ok, %{}} end
        ]
      ) do
        exploration_rover = %ExplorationRover{position: {0,0}, direction: "N", commands: ["M"]}
        direction = "L"
        assert NasaExplorationRoversControl.rotate_exploration_rover(exploration_rover, direction) == {:ok, %{}}

        assert_called Interactors.RotateExplorationRover.perform(exploration_rover, direction)
      end
    end
  end

  describe "move_exploration_rover/1" do
    test "calls the right interactor" do
      with_mock(
        Interactors.MoveExplorationRover,
        [
          perform: fn(_exploration_rover) -> {:ok, %{}} end
        ]
      ) do
        exploration_rover = %ExplorationRover{position: {0,0}, direction: "N", commands: ["M"]}
        assert NasaExplorationRoversControl.move_exploration_rover(exploration_rover) == {:ok, %{}}

        assert_called Interactors.MoveExplorationRover.perform(exploration_rover)
      end
    end
  end

end
