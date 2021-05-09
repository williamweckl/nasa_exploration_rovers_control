defmodule NASAExplorationRoversControlTerminalInterface.FinalStep do
  @moduledoc """
  This module contains for the final step at the interaction with the terminal interface.
  """

  import NASAExplorationRoversControlTerminalInterface.IO

  @terminal_interface_settings Application.get_env(
    :nasa_exploration_rovers_control,
    NASAExplorationRoversControlTerminalInterface
  )
  @file_module @terminal_interface_settings |> Keyword.fetch!(:file_module)
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @commands_output_files_path "priv/commands_output_files"

  @doc """
  Prompts the user if he wants to save the output to a file.

  Receives a state (map) but returns anything and halts the system.

  In case the user confirms, a file will be saved to the system at the path priv/commands_output_files containing the execution output.
  """
  def show_final_user_options_and_wait_for_interaction(
    %{selected_celestial_body: selected_celestial_body, execution_output: execution_output}
  ) do
    typing_effect_print(
      "So. That's it! We had a great time, what do you think?"
    )
    typing_effect_print(
      "What do you want to do now? Go out for a drink?"
    )
    typing_effect_print(
      "Just kidding. We have not finished yet."
    )

    user_choice = prompt_user_choice("Do you want me to save the output to a file? (Y/n)")
    if user_choice in ["Y", "y"] do
      saved_file_path = write_output_to_file(selected_celestial_body, execution_output)

      print_message "The file was saved at #{saved_file_path}."
      break_line()
      typing_effect_print(
        "Now I think we have finished. " <>
        "Thank you Xerpa for the opportunity to make me feel challenged again. See you soon. :)"
      )
      @system_module.halt(0)
    else
      break_line()
      print_message "OK then. Thank you Xerpa for the opportunity to make me feel challenged again. See you soon. :)"
      @system_module.halt(0)
    end
  end

  defp write_output_to_file(selected_celestial_body, execution_output) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    timestamp = datetime |> DateTime.to_unix()

    file_name = "exploration_done_by_xerga_guys_#{timestamp}"
    current_path = __ENV__.file
      |> String.replace("lib/nasa_exploration_rovers_control_terminal_interface/final_step.ex", "")

    directory_path = "#{current_path}/#{@commands_output_files_path}/#{selected_celestial_body.code}"
    @file_module.mkdir_p!(directory_path)

    path = "#{@commands_output_files_path}/#{selected_celestial_body.code}/#{file_name}"
    @file_module.write!(path, execution_output)

    path
  end

end
