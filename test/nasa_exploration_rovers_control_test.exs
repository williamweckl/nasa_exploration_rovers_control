defmodule NasaExplorationRoversControlTest do
  use ExUnit.Case
  doctest NasaExplorationRoversControl, import: true

  @commands_input_files_base_path "test/support/commands_input_files"

  describe "interpret_exploration_commands_input_file" do
    test "With a lot of exploration rovers returns valid result" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_2k_exploration_rovers"
      )

      exploration_rover = %NasaExplorationRoversControl.ExplorationRover{
        commands: ["L", "M"], direction: "N", position: {1, 2}
      }

      exploration_rovers = Enum.map(1..2000, fn _ ->
        exploration_rover
      end)

      assert result == {:ok, %{
        ground_size: {5, 5},
        exploration_rovers: exploration_rovers
      }}
    end

    test "With invalid exploration rover command at rover 1 returns exploration rover 1 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_invalid_exploration_rover_1_command"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Command `I` is invalid. Must be L, R or M."},
          %NasaExplorationRoversControl.ExplorationRover{commands: ["L", "M", "M"], direction: "N", position: {3, 8}}
        ]
      }}
    end

    test "With invalid exploration rover command at rover 2 returns exploration rover 2 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_invalid_exploration_rover_2_command"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          %NasaExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {0, 0}},
          {:error, "Command `P` is invalid. Must be L, R or M."}
        ]
      }}
    end

    test "Without exploration rover commands at rover 2 returns exploration rover 2 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/without_exploration_rover_commands"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          %NasaExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {0, 0}},
          {:error, "Commands list must not be empty."}
        ]
      }}
    end

    test "When exploration rover commands at rover 1 is an empty line returns exploration rover 1 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_exploration_rover_commands_empty_line"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Commands list must not be empty."},
          %NasaExplorationRoversControl.ExplorationRover{commands: ["M", "M", "M"], direction: "N", position: {3, 8}},
        ]
      }}
    end

    test "When exploration rover commands at rover 1 is an empty string returns exploration rover 1 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_exploration_rover_commands_empty_string"
      )

      assert result == {:ok, %{
        ground_size: {3, 5},
        exploration_rovers: [
          {:error, "Command ` ` is invalid. Must be L, R or M."},
          %NasaExplorationRoversControl.ExplorationRover{commands: ["L", "M"], direction: "W", position: {3, 3}},
        ]
      }}
    end

    test "Without exploration rovers initial position returns both exploration rovers with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
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

    test "When exploration rover initial position at rover 1 is an empty string " <>
         "returns exploration rover 1 with error" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/with_exploration_rover_initial_position_empty_string"
      )

      assert result == {:ok, %{
        ground_size: {3, 8},
        exploration_rovers: [
          {:error, "Position or direction are invalid."},
          %NasaExplorationRoversControl.ExplorationRover{
            commands: ["L", "M", "M", "M"], direction: "N", position: {0, 0}
          },
        ]
      }}
    end

    test "Without exploration rovers" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/without_exploration_rovers"
      )

      assert result == {:error, "Exploration rovers list is empty."}
    end

    test "Without ground size" do
      result = NasaExplorationRoversControl.interpret_exploration_commands_input_file(
        "#{@commands_input_files_base_path}/without_ground_size"
      )

      assert result == {:error, "Ground size is invalid."}
    end
  end

end
