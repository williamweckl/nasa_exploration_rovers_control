defmodule NASAExplorationRoversControlTerminalInterface.CommandsInputFilesMenuTest do
  use ExUnit.Case

  import Mock

  alias NASAExplorationRoversControlTerminalInterface.CommandsInputFilesMenu

  @selected_celestial_body %{
    id: 1,
    label: "Mars",
    code: "mars"
  }
  @custom_file_option_code "6"

  def assert_show_menu_options do
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "1) exploration_attempt_1_by_kayla_barron_2030_05_08"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "2) exploration_attempt_2_by_zena_cardman_2030_05_09"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "3) exploration_attempt_3_by_raja_chari_2030_05_11"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "4) exploration_attempt_4_by_zena_cardman_2030_05_11"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "5) exploration_attempt_5_by_kayla_barron_2030_05_11"
    )
    assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
      "6) I prefer to inform another file path"
    )
  end

  describe "show_menu_and_wait_for_user_interaction/1" do
    test "shows menu to user and persist state after user has chosen first option" do
      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(_message) -> "1" end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end
        ]
      ) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction(state)

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path:
            "priv/commands_input_files/mars/exploration_attempt_1_by_kayla_barron_2030_05_08"
        }

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Nice! Mars is a great Celestial Body! There is a lot of opportunities there!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "We can perform the instructions of a predefined command input file, " <>
          "or if you wish you can inform another file path from your file system."
        )
        assert_show_menu_options()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which option would be great for you today?"
        )
      end
    end

    test "shows menu to user and persist state after user has chosen third option" do
      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(_message) -> "3" end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end
        ]
      ) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction(state)

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path:
            "priv/commands_input_files/mars/exploration_attempt_3_by_raja_chari_2030_05_11"
        }

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Nice! Mars is a great Celestial Body! There is a lot of opportunities there!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "We can perform the instructions of a predefined command input file, " <>
          "or if you wish you can inform another file path from your file system."
        )
        assert_show_menu_options()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which option would be great for you today?"
        )
      end
    end

    test "asks for user to input file name when selecting the last option" do
      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(message) ->
            if message == "Which option would be great for you today?" do
              @custom_file_option_code
            else
              "my_file_path"
            end
          end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end
        ]
      ) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction(state)

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path: "my_file_path"
        }

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Nice! Mars is a great Celestial Body! There is a lot of opportunities there!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "We can perform the instructions of a predefined command input file, " <>
          "or if you wish you can inform another file path from your file system."
        )
        assert_show_menu_options()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which option would be great for you today?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Alright! Let me know the file path then"
        )
      end
    end

    test "shows menu to user and retries after user has chosen an invalid option" do
      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "10" end,
            wait_for_user_reading: fn -> :ok end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end
          ]
        },
        {
          CommandsInputFilesMenu,
          [:passthrough],
          [
            retry: fn(state) -> state end
          ]
        }
      ]) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction(state)

        assert new_state == state

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Nice! Mars is a great Celestial Body! There is a lot of opportunities there!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "We can perform the instructions of a predefined command input file, " <>
          "or if you wish you can inform another file path from your file system."
        )
        assert_show_menu_options()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which option would be great for you today?"
        )

        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Sorry, I did not understand the typed option."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading()
        assert_called CommandsInputFilesMenu.retry(%{})
      end
    end

    test "shows menu to user and retries after user has chosen an invalid string option" do
      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "string" end,
            wait_for_user_reading: fn -> :ok end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end
          ]
        },
        {
          CommandsInputFilesMenu,
          [:passthrough],
          [
            retry: fn(state) -> state end
          ]
        }
      ]) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction(state)

        assert new_state == state

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Nice! Mars is a great Celestial Body! There is a lot of opportunities there!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "We can perform the instructions of a predefined command input file, " <>
          "or if you wish you can inform another file path from your file system."
        )
        assert_show_menu_options()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which option would be great for you today?"
        )

        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Sorry, I did not understand the typed option."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading()
        assert_called CommandsInputFilesMenu.retry(%{})
      end
    end
  end

  describe "retry/1" do
    test "shows menu to user and persist state after user has chosen Mars" do
      with_mock(
        NASAExplorationRoversControlTerminalInterface.IO,
        [
          typing_effect_print: fn(message) -> message end,
          print_message: fn(message) -> message end,
          prompt_user_choice: fn(_message) -> "1" end,
          clear_screen: fn -> :ok end,
          break_line: fn -> :ok end
        ]
      ) do
        state = %{selected_celestial_body: @selected_celestial_body}
        new_state = CommandsInputFilesMenu.retry(state)

        assert new_state == %{
          selected_celestial_body: @selected_celestial_body,
          selected_commands_input_file_path:
            "priv/commands_input_files/mars/exploration_attempt_1_by_kayla_barron_2030_05_08"
        }
      end
    end
  end

end