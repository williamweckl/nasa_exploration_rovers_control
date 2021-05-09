defmodule NASAExplorationRoversControlTerminalInterface.CelestialBodiesMenuTest do
  use ExUnit.Case

  import Mock

  alias NASAExplorationRoversControlTerminalInterface.CelestialBodiesMenu

  describe "show_menu_and_wait_for_user_interaction/1" do
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
        new_state = CelestialBodiesMenu.show_menu_and_wait_for_user_interaction(%{})

        assert new_state == %{selected_celestial_body: %{code: "mars", id: 1, label: "Mars"}}

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "The system covered celestial bodies for now are:"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "1) Mars"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "When you are ready, choose an option from the above list."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which celestial body do you want to explore today?"
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
            prompt_user_choice: fn(_message) -> "2" end,
            wait_for_user_reading: fn -> :ok end,
            clear_screen: fn -> :ok end,
            break_line: fn -> :ok end
          ]
        },
        {
          CelestialBodiesMenu,
          [:passthrough],
          [
            retry: fn(state) -> state end
          ]
        }
      ]) do
        new_state = CelestialBodiesMenu.show_menu_and_wait_for_user_interaction(%{})

        assert new_state == %{}

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "The system covered celestial bodies for now are:"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "1) Mars"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "When you are ready, choose an option from the above list."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which celestial body do you want to explore today?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Sorry, we do not have this option yet. Maybe in the future."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading()
        assert_called CelestialBodiesMenu.retry(%{})
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
          CelestialBodiesMenu,
          [:passthrough],
          [
            retry: fn(state) -> state end
          ]
        }
      ]) do
        new_state = CelestialBodiesMenu.show_menu_and_wait_for_user_interaction(%{})

        assert new_state == %{}

        assert_called NASAExplorationRoversControlTerminalInterface.IO.clear_screen()
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "The system covered celestial bodies for now are:"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.print_message(
          "1) Mars"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "When you are ready, choose an option from the above list."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.prompt_user_choice(
          "Which celestial body do you want to explore today?"
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.typing_effect_print(
          "Sorry, we do not have this option yet. Maybe in the future."
        )
        assert_called NASAExplorationRoversControlTerminalInterface.IO.wait_for_user_reading()
        assert_called CelestialBodiesMenu.retry(%{})
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
        new_state = CelestialBodiesMenu.retry(%{})

        assert new_state == %{selected_celestial_body: %{code: "mars", id: 1, label: "Mars"}}
      end
    end
  end

end