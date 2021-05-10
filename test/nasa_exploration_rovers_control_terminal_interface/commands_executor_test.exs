defmodule NASAExplorationRoversControlTerminalInterface.CommandsExecutorTest do
  use ExUnit.Case

  import Mock

  alias NASAExplorationRoversControlTerminalInterface.CommandsExecutor

  @terminal_interface_settings Application.compile_env(
    :nasa_exploration_rovers_control,
    NASAExplorationRoversControlTerminalInterface
  )
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @selected_celestial_body %{
    id: 1,
    label: "Mars",
    code: "mars"
  }

  def assert_show_messages(selected_commands_input_file_path) do
    assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
      "Good to know!"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
      "We will initialize the exploration to Mars now following the " <>
      "instructions presented at the file `#{selected_commands_input_file_path}`."
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
      "Take a look at the instructions again. Your commands will take about " <>
      "8 minutes to be delivered to the Exploration Rovers."
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
      "Before the execution, the system will try to prevent some common mistakes like " <>
      "Exploration Rovers getting out from the exploration ground, but it doesn't hurt to take another look."
    )
    assert_called_exactly NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading(), 2
    assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
      "These are the commands we will deliver to the Exploration Rovers:"
    )
  end

  describe "explore_celestial_body_using_commands_from_selected_file/1" do
    test "shows user a summary of the commands that will be performed and after user confirms returns the new state" do
      selected_commands_input_file_path =
        "priv/commands_input_files/mars/exploration_attempt_2_by_zena_cardman_2030_05_09"

      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(_message) -> "y" end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end,
          wait_for_user_reading: fn -> :ok end,
          wait_for_user_reading: fn (5000) -> :ok end
        ]
      ) do
        state = %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path
        }
        new_state = CommandsExecutor.explore_celestial_body_using_commands_from_selected_file(state)

        execution_output = "0 3 N\n0 8 W"

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path,
          execution_output: execution_output
        }

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_show_messages(selected_commands_input_file_path)
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          File.read!(selected_commands_input_file_path)
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want to continue? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "The operation has been performed successfuly! See the output below:"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          execution_output
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "The output above shows where the rovers will be after the movement."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "But don't forget that the exploration rovers will start to move only when the commands arrive to them."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading(5000)
      end
    end

    test "returns errors at output when there are errors with some exploration rovers" do
      selected_commands_input_file_path =
        "priv/commands_input_files/mars/exploration_attempt_3_by_raja_chari_2030_05_11"

      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(_message) -> "y" end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end,
          wait_for_user_reading: fn -> :ok end,
          wait_for_user_reading: fn (5000) -> :ok end
        ]
      ) do
        state = %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path
        }
        new_state = CommandsExecutor.explore_celestial_body_using_commands_from_selected_file(state)

        execution_output = "0 4 N\n0 8 W\nThere is something wrong with the initial position of this rover. " <>
                           "It is the same as Rover 1 and it is probably wrong as the system prevents rover " <>
                           "collisions. Please fix it and try again.\n1 1 W\nThere is something wrong with the " <>
                           "initial position of this rover. It is the same as Rover 1 and it is probably wrong " <>
                           "as the system prevents rover collisions. Please fix it and try again.\n" <>
                           "The system prevented the exploration rover from leaving the ground. " <>
                           "Check the commands and try again. The exploration rover was kept in the " <>
                           "initial position and direction."

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path,
          execution_output: execution_output
        }

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_show_messages(selected_commands_input_file_path)
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          File.read!(selected_commands_input_file_path)
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want to continue? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "The operation has been performed successfuly! See the output below:"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          execution_output
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "The output above shows where the rovers will be after the movement."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "But don't forget that the exploration rovers will start to move only when the commands arrive to them."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading(5000)
      end
    end

    test "returns error when the file is not valid according to the celestial body validation" do
      selected_commands_input_file_path =
        "priv/commands_input_files/mars/exploration_attempt_1_by_kayla_barron_2030_05_08"

      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "y" end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end,
            wait_for_user_reading: fn -> :ok end,
          ]
        },
        {
          @system_module,
          [],
          [
            halt: fn(0) -> :halted end
          ]
        }
      ]) do
        state = %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path
        }
        new_state = CommandsExecutor.explore_celestial_body_using_commands_from_selected_file(state)

        assert new_state == :halted

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_show_messages(selected_commands_input_file_path)
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          File.read!(selected_commands_input_file_path)
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want to continue? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "The operation has been performed with errors."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "The terrain of mars is rectangular and the value entered is a square. Please check your commands."
        )
      end
    end

    test "returns error when the file does not exist" do
      selected_commands_input_file_path = "invalid"

      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end,
            wait_for_user_reading: fn -> :ok end,
          ]
        },
        {
          @system_module,
          [],
          [
            halt: fn(0) -> :halted end
          ]
        }
      ]) do
        state = %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path
        }
        new_state = CommandsExecutor.explore_celestial_body_using_commands_from_selected_file(state)

        assert new_state == :halted

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_show_messages(selected_commands_input_file_path)
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "Oops. Looks like the informed file does not exist. " <>
          "I'll be gone for now but you can call me again anytime you want."
        )
      end
    end

    test "returns message and halts when user not confirm" do
      selected_commands_input_file_path =
        "priv/commands_input_files/mars/exploration_attempt_2_by_zena_cardman_2030_05_09"

      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "n" end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end,
            wait_for_user_reading: fn -> :ok end,
          ]
        },
        {
          @system_module,
          [],
          [
            halt: fn(0) -> :halted end
          ]
        }
      ]) do
        state = %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: selected_commands_input_file_path
        }
        new_state = CommandsExecutor.explore_celestial_body_using_commands_from_selected_file(state)

        assert new_state == :halted

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_show_messages(selected_commands_input_file_path)
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          File.read!(selected_commands_input_file_path)
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want to continue? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "OK then, I'll be here to help in another time."
        )
      end
    end
  end

end