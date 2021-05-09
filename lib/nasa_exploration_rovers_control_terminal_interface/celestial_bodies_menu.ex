defmodule NasaExplorationRoversControlTerminalInterface.CelestialBodiesMenu do
  @moduledoc """
  This module contains logic to show terminal interface celestial bodies menu to user and to handle user interactions.
  """

  import NasaExplorationRoversControlTerminalInterface.IO

  @celestial_bodies_allowed [
    %{
      id: 1,
      label: "Mars",
      code: "mars"
    }
  ]

  @doc """
  Shows celestial bodies menu to user and handle interactions.

  Receives a state (map) and returns a state with the user's choice appended.
  """
  def show_menu_and_wait_for_user_interaction(%{} = state) do
    clear_screen()
    typing_effect_print("The system covered celestial bodies for now are:")
    show_menu()
    typing_effect_print("When you are ready, choose an option from the above list.")

    user_choice = ask_for_user_choice()

    if valid_celestial_body_menu_choice?(user_choice) do
      state |> add_choice_to_state(user_choice)
    else
      typing_effect_print("Sorry, we do not have this option yet. Maybe in the future.")
      wait_for_user_reading()
      __MODULE__.retry(state)
    end
  end

  @doc """
  Retries to show menu and wait for user interaction.

  It is an alias to show_menu_and_wait_for_user_interaction but was splitted to be able to test the retry mechanism.
  """
  def retry(state) do
    show_menu_and_wait_for_user_interaction(state)
  end

  defp show_menu do
    print_message "========================================"
    Enum.each(@celestial_bodies_allowed, fn %{id: id, label: label} ->
      print_message "#{id}) #{label}"
    end)
    print_message "========================================"
    break_line()
  end

  defp ask_for_user_choice do
    prompt_user_choice("Which celestial body do you want to explore today?")
  end

  defp valid_celestial_body_menu_choice?(choice) do
    valid_ids = Enum.map(@celestial_bodies_allowed, fn %{id: id} ->
      id
    end)

    String.to_integer(choice) in valid_ids
  rescue
    ArgumentError ->
      false
  end

  defp add_choice_to_state(state, user_choice) do
    selected_celestial_body = Enum.find(@celestial_bodies_allowed, fn celestial_body ->
      celestial_body.id == String.to_integer(user_choice)
    end)

    state |> Map.put(:selected_celestial_body, selected_celestial_body)
  end

end
