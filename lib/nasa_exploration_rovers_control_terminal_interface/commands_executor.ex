defmodule NasaExplorationRoversControlTerminalInterface.CommandsExecutor do
  @moduledoc """
  This module contains logic to execute commands from selected file by user.
  """

  import NasaExplorationRoversControlTerminalInterface.IO

  alias NasaExplorationRoversControl.CelestialBodies

  @terminal_interface_settings Application.get_env(
    :nasa_exploration_rovers_control,
    NasaExplorationRoversControlTerminalInterface
  )
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @doc """
  Executes the exploration commands contained in the file chosen by user.

  It shows a summary before the execution and waits for a confirmation.

  Receives a state (map) and returns a state with the user's choice appended.

  In case of the file does not exist or user does not confirm, it will halt without any returns.
  """
  def explore_celestial_body_using_commands_from_selected_file(
    %{
      selected_celestial_body: selected_celestial_body,
      selected_commands_input_file_path: selected_commands_input_file_path
    } = state
  ) do
    clear_screen()
    typing_effect_print("Good to know!")
    typing_effect_print(
      "We will initialize the exploration to #{selected_celestial_body.label} now following the " <>
      "instructions presented at the file `#{selected_commands_input_file_path}`."
    )

    {:ok, celestial_body_module} = CelestialBodies.Factory.get_celestial_body_module(selected_celestial_body.code)

    show_instructions_before_execution(celestial_body_module)
    wait_for_user_reading()
    show_commands_execution_summary(selected_commands_input_file_path)

    user_confirmation = prompt_user_choice("Do you want to continue? (Y/n)")
    if user_confirmation in ["Y", "y"] do
      state
      |> do_explore_celestial_body_using_commands_from_file()
    else
      print_message("OK then, I'll be here to help in another time.")
      @system_module.halt(0)
    end
  rescue
    File.Error ->
      print_message(
        "Oops. Looks like the informed file does not exist. " <>
        "I'll be gone for now but you can call me again anytime you want."
      )
      @system_module.halt(0)
  end

  defp show_instructions_before_execution(celestial_body_module) do
    average_time_for_exploration_rovers_to_receive_commands =
      celestial_body_module.average_time_for_exploration_rovers_to_receive_commands()

    typing_effect_print(
      "Take a look at the instructions again. Your commands will take about " <>
      "#{average_time_for_exploration_rovers_to_receive_commands} to be delivered to the Exploration Rovers."
    )
    typing_effect_print(
      "Before the execution, the system will try to prevent some common mistakes like " <>
      "Exploration Rovers getting out from the exploration ground, but it doesn't hurt to take another look."
    )
  end

  def show_commands_execution_summary(selected_commands_input_file_path) do
    typing_effect_print("These are the commands we will deliver to the Exploration Rovers:")

    wait_for_user_reading()

    break_line()
    print_message "=================================================================="
    print_message File.read!(selected_commands_input_file_path)
    print_message "=================================================================="
    break_line()
    break_line()
  end

  defp do_explore_celestial_body_using_commands_from_file(
    %{
      selected_celestial_body: selected_celestial_body,
      selected_commands_input_file_path: selected_commands_input_file_path
    } = state
  ) do
    result = NasaExplorationRoversControl.explore_celestial_body_using_commands_from_file(
      selected_celestial_body.code, selected_commands_input_file_path
    )

    case result do
      {:ok, output} ->
        converted_output = convert_explore_result_to_the_same_format_as_the_input_file(output)

        break_line()
        print_message("The operation has been performed successfuly! See the output below:")
        break_line()

        print_message "=================================================================="
        print_message converted_output
        print_message "=================================================================="

        break_line()
        typing_effect_print("The output above shows where the rovers will be after the movement.")
        typing_effect_print(
          "But don't forget that the exploration rovers will start to move only when the commands arrive to them."
        )
        wait_for_user_reading(5000)

        state |> add_output_to_state(converted_output)

      {:error, error_message} ->
        print_message("The operation has been performed with errors.")
        print_message(error_message)

        @system_module.halt(0)
    end
  end

  defp convert_explore_result_to_the_same_format_as_the_input_file(explore_result) do
    explore_result.exploration_rovers
    |> Enum.reduce("", fn exploration_rover, acc ->
      case exploration_rover do
        {:error, error_message} ->
          "#{acc}\n#{error_message}"
        _ ->
          {x, y} = exploration_rover.position
          "#{acc}\n#{x} #{y} #{exploration_rover.direction}"
      end
    end)
    |> String.replace("\n", "", global: false)
  end

  defp add_output_to_state(state, converted_output) do
    state |> Map.put(:execution_output, converted_output)
  end

end
