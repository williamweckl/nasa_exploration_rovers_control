defmodule NASAExplorationRoversControl.Interactors.InterpretExplorationCommandsInputFileTest do
  use ExUnit.Case

  alias NASAExplorationRoversControl.Interactors.InterpretExplorationCommandsInputFile

  @commands_input_files_base_path "test/support/commands_input_files"

  describe "perform/1" do
    test "with a lot of exploration rovers returns valid result" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_2k_exploration_rovers"
      )

      exploration_rovers = Enum.map(1..2000, fn index ->
        %NASAExplorationRoversControl.ExplorationRover{
          commands: ["M"], direction: "N", position: {index, 1}
        }
      end)

      assert result == {:ok, %{
        ground_size: {2000, 5},
        exploration_rovers: exploration_rovers
      }}
    end

    test "with invalid exploration rover command at rover 1 returns exploration rover 1 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_invalid_exploration_rover_1_command"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Command `I` is invalid. Must be L, R or M."},
          %NASAExplorationRoversControl.ExplorationRover{commands: ["L", "M", "M"], direction: "N", position: {3, 8}}
        ]
      }}
    end

    test "with invalid exploration rover command at rover 2 returns exploration rover 2 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_invalid_exploration_rover_2_command"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          %NASAExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {0, 0}},
          {:error, "Command `P` is invalid. Must be L, R or M."}
        ]
      }}
    end

    test "without exploration rover commands at rover 2 returns exploration rover 2 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/without_exploration_rover_commands"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          %NASAExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {0, 0}},
          {:error, "Commands list must not be empty."}
        ]
      }}
    end

    test "when exploration rover commands at rover 1 is an empty line returns exploration rover 1 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_exploration_rover_commands_empty_line"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Commands list must not be empty."},
          %NASAExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {3, 8}},
        ]
      }}
    end

    test "when exploration rover commands at rover 1 is an empty string returns exploration rover 1 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_exploration_rover_commands_empty_string"
      )

      assert result == {:ok, %{
        ground_size: {3, 5},
        exploration_rovers: [
          {:error, "Command ` ` is invalid. Must be L, R or M."},
          %NASAExplorationRoversControl.ExplorationRover{commands: ["L", "M"], direction: "W", position: {3, 3}},
        ]
      }}
    end

    test "without exploration rovers initial position returns both exploration rovers with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/without_exploration_rover_initial_position"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Position or direction are invalid."},
          {:error, "Position or direction are invalid."}
        ]
      }}
    end

    test "when exploration rover initial position at rover 1 is an empty string " <>
         "returns exploration rover 1 with error" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_exploration_rover_initial_position_empty_string"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Position or direction are invalid."},
          %NASAExplorationRoversControl.ExplorationRover{
            commands: ["L", "M", "M", "M"], direction: "N", position: {0, 0}
          },
        ]
      }}
    end

    test "without exploration rovers" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/without_exploration_rovers"
      )

      assert result == {:error, "Exploration rovers list is empty."}
    end

    test "without ground size" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/without_ground_size"
      )

      assert result == {:error, "Ground size is invalid."}
    end

    test "with two rovers in the same initial position" do
      result = InterpretExplorationCommandsInputFile.perform(
        "#{@commands_input_files_base_path}/with_two_rovers_at_the_same_initial_position"
      )

      assert result == {:ok, %{
        ground_size: {10, 11},
        exploration_rovers: [
          %NASAExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M", "L", "R", "M"], direction: "N", position: {0, 0}},
          %NASAExplorationRoversControl.ExplorationRover{commands: ["L", "M"], direction: "N", position: {3, 8}},
          {:error, "There is something wrong with the initial position of this rover. It is the same as Rover 1 and it is probably wrong as the system prevents rover collisions. Please fix it and try again."}
        ]
      }}
    end
  end

end
