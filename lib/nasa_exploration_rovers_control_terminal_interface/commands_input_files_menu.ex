defmodule NASAExplorationRoversControlTerminalInterface.CommandsInputFilesMenu do
  @moduledoc """
  This module contains logic to show terminal interface command input files menu to user and to handle user interactions.
  """

  import NASAExplorationRoversControlTerminalInterface.IO

  @predefined_commands_input_files_path "priv/commands_input_files"

  @doc """
  Shows commands input files menu to user and handle interactions.

  Receives a state (map) and returns a state with the user's choice appended.
  """
  def show_menu_and_wait_for_user_interaction(%{selected_celestial_body: selected_celestial_body} = state) do
    clear_screen()
    typing_effect_print(
      "Nice! #{selected_celestial_body.label} is a great Celestial Body! There is a lot of opportunities there!"
    )

    typing_effect_print(
      "We can perform the instructions of a predefined command input file, " <>
      "or if you wish you can inform another file path from your file system."
    )

    predefined_files = selected_celestial_body
    |> retrieve_predefined_files()

    show_menu(predefined_files)

    user_choice = ask_for_user_choice()

    if valid_menu_choice?(user_choice, predefined_files) do
      integer_user_choice = String.to_integer(user_choice)

      file_path = if predefined_command_file_chosen?(integer_user_choice, predefined_files) do
        file_name = Enum.at(predefined_files, integer_user_choice - 1)
        "#{@predefined_commands_input_files_path}/#{selected_celestial_body.code}/#{file_name}"
      else
        ask_for_user_file_path()
      end

      state |> add_choice_to_state(file_path)
    else
      typing_effect_print("Sorry, I did not understand the typed option.")
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

  defp show_menu(predefined_files) do
    print_message "========================================"

    predefined_files
    |> Enum.with_index()
    |> Enum.each(fn {file, index} ->
      print_message "#{index + 1}) #{file}"
    end)

    print_message "#{Enum.count(predefined_files) + 1}) I prefer to inform another file path"

    print_message "========================================"
    break_line()
  end

  defp ask_for_user_choice do
    prompt_user_choice("Which option would be great for you today?")
  end

  defp ask_for_user_file_path do
    prompt_user_choice("Alright! Let me know the file path then")
  end

  defp retrieve_predefined_files(selected_celestial_body) do
    "#{@predefined_commands_input_files_path}/#{selected_celestial_body.code}"
    |> File.ls!()
    |> Enum.sort()
  end

  defp valid_menu_choice?(choice, predefined_files) do
    choices_available = Enum.count(predefined_files) + 1
    integer_choice = String.to_integer(choice)

    integer_choice > 0 && integer_choice <= choices_available
  rescue
    ArgumentError ->
      false
  end

  defp predefined_command_file_chosen?(user_choice, predefined_files) do
    predefined_choices = Enum.count(predefined_files)

    user_choice <= predefined_choices
  end

  defp add_choice_to_state(state, file_path) do
    state |> Map.put(:selected_commands_input_file_path, file_path)
  end

end
