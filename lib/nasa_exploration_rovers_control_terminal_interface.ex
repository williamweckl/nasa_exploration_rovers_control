defmodule NasaExplorationRoversControlTerminalInterface do
  @moduledoc """
  This module is a bridge between the user and the application business logic (aka. Delivery Mechanism).

  User is able to interact with the business logic using a terminal interface.
  """

  import NasaExplorationRoversControlTerminalInterface.IO

  alias NasaExplorationRoversControlTerminalInterface.CelestialBodiesMenu
  alias NasaExplorationRoversControlTerminalInterface.CommandsExecutor
  alias NasaExplorationRoversControlTerminalInterface.CommandsInputFilesMenu
  alias NasaExplorationRoversControlTerminalInterface.FinalStep

  @nasa_banner "   '##::: ##::::'###:::::'######:::::'###::::
    ###:: ##:::'## ##:::'##... ##:::'## ##:::
    ####: ##::'##:. ##:: ##:::..:::'##:. ##::
    ## ## ##:'##:::. ##:. ######::'##:::. ##:
    ##. ####: #########::..... ##: #########:
    ##:. ###: ##.... ##:'##::: ##: ##.... ##:
    ##::. ##: ##:::: ##:. ######:: ##:::: ##:
   ..::::..::..:::::..:::......:::..:::::..::"
  @exploration_rovers_banner "      +-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+
      |E|X|P|L|O|R|A|T|I|O|N| |R|O|V|E|R|S|
      +-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+"
  @control_banner "                +-+-+-+-+-+-+-+
                |C|O|N|T|R|O|L|
                +-+-+-+-+-+-+-+"

  @doc """
  Starts the interaction with the user using the terminal interface.

  User will be followed through the steps:

  1) Selection of the celestial body to make the exploration
  2) Selection of the file with the commands to be executed
  3) The commands are executed with a user confirmation
  4) User has the option to save the output to a file
  """
  def start do
    clear_screen()
    print_banners()
    print_welcome_message()

    initial_state = %{}
    begin_user_interaction(initial_state)
  end

  defp begin_user_interaction(state) do
    state
    |> CelestialBodiesMenu.show_menu_and_wait_for_user_interaction()
    |> CommandsInputFilesMenu.show_menu_and_wait_for_user_interaction()
    |> CommandsExecutor.explore_celestial_body_using_commands_from_selected_file()
    |> FinalStep.show_final_user_options_and_wait_for_interaction()
  end

  defp print_welcome_message() do
    typing_effect_print("Hi Explorer! Welcome back!")
    typing_effect_print("This system was developed to control exploration rovers over celestial bodies.")
    typing_effect_print("You are about to control you exploration rovers at a celestial body, aren't you excited?")
    typing_effect_print("Alright! Let's begin then.")
    wait_for_user_reading()
  end

  defp print_banners do
    print_message @nasa_banner
    break_line()
    print_message @exploration_rovers_banner
    print_message @control_banner
    wait_for_user_reading()
  end

end
