defmodule NASAExplorationRoversControlTerminalInterfaceTest do
  use ExUnit.Case

  import Mock
  alias NASAExplorationRoversControlTerminalInterface.CelestialBodiesMenu
  alias NASAExplorationRoversControlTerminalInterface.CommandsExecutor
  alias NASAExplorationRoversControlTerminalInterface.CommandsInputFilesMenu
  alias NASAExplorationRoversControlTerminalInterface.FinalStep

  @selected_celestial_body %{
    id: 1,
    label: "Mars",
    code: "mars"
  }
  @selected_commands_input_file_path "priv/commands_input_files/mars/exploration_attempt_2_by_zena_cardman_2030_05_09"
  @execution_output "0 3 N\n0 8 W"

  describe "start/0" do
    test "shows initial messages and calls all the steps" do
      with_mocks([
        {
          NASAExplorationRoversControlTerminalInterface.IO,
          [],
          [
            clear_screen: fn -> :ok end,
            typing_effect_print: fn(message) -> message end,
            print_message: fn(message) -> message end,
            break_line: fn -> :ok end,
            wait_for_user_reading: fn -> :ok end
          ]
        },
        {
          CelestialBodiesMenu,
          [],
          [
            show_menu_and_wait_for_user_interaction: fn(state) ->
              assert state == %{}
              state |> Map.put(:selected_celestial_body, @selected_celestial_body)
            end
          ]
        },
        {
          CommandsInputFilesMenu,
          [],
          [
            show_menu_and_wait_for_user_interaction: fn(state) ->
              assert state == %{
                selected_celestial_body: @selected_celestial_body
              }
              state |> Map.put(:selected_commands_input_file_path, @selected_commands_input_file_path)
            end
          ]
        },
        {
          CommandsExecutor,
          [],
          [
            explore_celestial_body_using_commands_from_selected_file: fn(state) ->
              assert state == %{
                selected_celestial_body: @selected_celestial_body,
                selected_commands_input_file_path: @selected_commands_input_file_path
              }
              state |> Map.put(:execution_output, @execution_output)
            end
          ]
        },
        {
          FinalStep,
          [],
          [
            show_final_user_options_and_wait_for_interaction: fn(state) ->
              assert state == %{
                selected_celestial_body: @selected_celestial_body,
                selected_commands_input_file_path: @selected_commands_input_file_path,
                execution_output: @execution_output
              }
              :halt
            end
          ]
        }
      ]) do
        assert NASAExplorationRoversControlTerminalInterface.start() == :halt

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Hi Explorer! Welcome back!"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "This system was developed to control exploration rovers over celestial bodies."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "You are about to control you exploration rovers at a celestial body, aren't you excited?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Alright! Let's begin then."
        )
        assert_called_exactly NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading(), 2
      end
    end
  end

end
