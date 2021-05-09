defmodule NASAExplorationRoversControlTerminalInterface.FinalStepTest do
  use ExUnit.Case

  import Mock

  alias NASAExplorationRoversControlTerminalInterface.FinalStep

  @terminal_interface_settings Application.compile_env(
    :nasa_exploration_rovers_control,
    NASAExplorationRoversControlTerminalInterface
  )
  @file_module @terminal_interface_settings |> Keyword.fetch!(:file_module)
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @selected_celestial_body %{
    id: 1,
    label: "Mars",
    code: "mars"
  }
  @selected_commands_input_file_path "priv/commands_input_files/mars/exploration_attempt_2_by_zena_cardman_2030_05_09"
  @execution_output "0 3 N\n0 8 W"

  describe "show_final_user_options_and_wait_for_interaction/1" do
    test "saves file content to disk when user confirms" do
      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "y" end,
            break_line: fn -> :ok end
          ]
        },
        {
          @file_module,
          [],
          [
            mkdir_p!: fn(path) ->
              current_path = __ENV__.file
                |> String.replace("test/nasa_exploration_rovers_control_terminal_interface/final_step_test.exs", "")
              assert path == "#{current_path}/priv/commands_output_files/mars"

              :ok
            end,
            write!: fn(path, content) ->
              assert String.contains?(path, "priv/commands_output_files/mars/exploration_done_by_xerga_guys_")
              assert content == @execution_output
              :ok
            end
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
          selected_commands_input_file_path: @selected_commands_input_file_path,
          execution_output: @execution_output
        }
        new_state = FinalStep.show_final_user_options_and_wait_for_interaction(state)

        assert new_state == :halted

        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "So. That's it! We had a great time, what do you think?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "What do you want to do now? Go out for a drink?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Just kidding. We have not finished yet."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want me to save the output to a file? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Now I think we have finished. " <>
          "Thank you Xerpa for the opportunity to make me feel challenged again. See you soon. :)"
        )
      end
    end

    test "does not save file content to disk when user does not confirm" do
      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            prompt_user_choice: fn(_message) -> "n" end,
            break_line: fn -> :ok end
          ]
        },
        {
          @file_module,
          [],
          [
            mkdir_p!: fn(_path) -> :ok end,
            write!: fn(_path, _content) -> :ok end
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
          selected_commands_input_file_path: @selected_commands_input_file_path,
          execution_output: @execution_output
        }
        new_state = FinalStep.show_final_user_options_and_wait_for_interaction(state)

        assert new_state == :halted

        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "So. That's it! We had a great time, what do you think?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "What do you want to do now? Go out for a drink?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Just kidding. We have not finished yet."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Do you want me to save the output to a file? (Y/n)"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "OK then. Thank you Xerpa for the opportunity to make me feel challenged again. See you soon. :)"
        )

        assert_not_called @file_module.mkdir_p!(:_)
        assert_not_called @file_module.write!(:_, :_)
      end
    end
  end

end