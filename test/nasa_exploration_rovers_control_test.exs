defmodule NASAExplorationRoversControlTest do
  use ExUnit.Case
  doctest NASAExplorationRoversControl, import: true

  import Mock
  alias NASAExplorationRoversControl.ExplorationRover
  alias NASAExplorationRoversControl.Interactors

  describe "explore_celestial_body_using_commands_from_file/2" do
    test "calls the right interactor" do
      with_mock(
        Interactors.ExploreCelestialBodyUsingCommandsFromFile,
        [
          perform: fn(_celestial_body_name, _input_file) -> {:ok, %{}} end
        ]
      ) do
        celestial_body_name = "fake celestial body name"
        input_file = "fake input file"
        assert NASAExplorationRoversControl.explore_celestial_body_using_commands_from_file(
          celestial_body_name, input_file
        ) == {:ok, %{}}

        assert_called Interactors.ExploreCelestialBodyUsingCommandsFromFile.perform(celestial_body_name, input_file)
      end
    end
  end

  describe "interpret_exploration_commands_input_file/1" do
    test "calls the right interactor" do
      with_mock(
        Interactors.InterpretExplorationCommandsInputFile,
        [
          perform: fn(_input_file) -> {:ok, %{}} end
        ]
      ) do
        input_file = "fake input file"
        assert NASAExplorationRoversControl.interpret_exploration_commands_input_file(input_file) == {:ok, %{}}

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
        exploration_rover = %ExplorationRover{position: {0, 0}, direction: "N", commands: ["M"]}
        assert NASAExplorationRoversControl.execute_exploration_rover_commands(exploration_rover) == {:ok, %{}}

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
        exploration_rover = %ExplorationRover{position: {0, 0}, direction: "N", commands: ["M"]}
        direction = "L"
        assert NASAExplorationRoversControl.rotate_exploration_rover(exploration_rover, direction) == {:ok, %{}}

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
        exploration_rover = %ExplorationRover{position: {0, 0}, direction: "N", commands: ["M"]}
        assert NASAExplorationRoversControl.move_exploration_rover(exploration_rover) == {:ok, %{}}

        assert_called Interactors.MoveExplorationRover.perform(exploration_rover)
      end
    end
  end

end
