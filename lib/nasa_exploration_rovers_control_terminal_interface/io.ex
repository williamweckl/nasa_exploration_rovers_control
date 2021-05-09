defmodule NasaExplorationRoversControlTerminalInterface.IO do
  @moduledoc """
  This module contains helpers for interacting with the user's terminal.
  """

  @terminal_interface_settings Application.get_env(
    :nasa_exploration_rovers_control,
    NasaExplorationRoversControlTerminalInterface
  )
  @io_module @terminal_interface_settings |> Keyword.fetch!(:io_module)
  @timer_module @terminal_interface_settings |> Keyword.fetch!(:timer_module)
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @typing_effect_print_time @terminal_interface_settings |> Keyword.fetch!(:typing_effect_print_time)
  @user_reading_time @terminal_interface_settings |> Keyword.fetch!(:user_reading_time)

  @doc """
  Write a message to terminal with a typing effect.
  """
  def typing_effect_print(message) do
    message
    |> String.codepoints()
    |> Enum.each(fn char ->
      print_message(char, without_line_break: true)
      @timer_module.sleep(@typing_effect_print_time)
    end)

    break_line()
    break_line()
  end

  @doc """
  Clears the user's terminal screen.
  """
  def clear_screen do
    @system_module.cmd("clear", [], into: IO.stream(:stdio, :line))
  end

  @doc """
  Prints message to the user's terminal.
  """
  def print_message(message) do
    @io_module.puts(message)
  end

  @doc """
  Prints message to the user's terminal without breaking line.
  """
  def print_message(message, without_line_break: true) do
    @io_module.write(message)
  end

  @doc """
  Breaks line at the user's terminal.
  """
  def break_line do
    @io_module.write("\n")
  end

  @doc """
  Prompts the user for a choice.
  """
  def prompt_user_choice(prompt_message) do
    print_message("#{prompt_message}: ", without_line_break: true)
    choice = @io_module.read(:stdio, :line)

    choice |> String.replace("\n", "")
  end

  @doc """
  Waits a time to be able to user to read a message printed before.
  """
  def wait_for_user_reading do
    @timer_module.sleep(@user_reading_time)
  end
  def wait_for_user_reading(custom_time) do
    @timer_module.sleep(custom_time)
  end

end
