defmodule NasaExplorationRoversControlTerminalInterface.IOTest do
  use ExUnit.Case

  import Mock

  @terminal_interface_settings Application.get_env(
    :nasa_exploration_rovers_control,
    NasaExplorationRoversControlTerminalInterface
  )
  @io_module @terminal_interface_settings |> Keyword.fetch!(:io_module)
  @timer_module @terminal_interface_settings |> Keyword.fetch!(:timer_module)
  @system_module @terminal_interface_settings |> Keyword.fetch!(:system_module)

  @user_reading_time @terminal_interface_settings |> Keyword.fetch!(:user_reading_time)
  @typing_effect_print_time @terminal_interface_settings |> Keyword.fetch!(:typing_effect_print_time)

  describe "typing_effect_print/1" do
    test "calls io module write for each character and sleeps" do
      with_mocks([
        {
          @io_module,
          [],
          [
            write: fn(message) -> message end
          ]
        },
        {
          @timer_module,
          [],
          [
            sleep: fn(sleep_time) ->
              assert sleep_time == @typing_effect_print_time
              :ok
            end
          ]
        }
      ]) do
        NasaExplorationRoversControlTerminalInterface.IO.typing_effect_print("My message")

        assert_called @io_module.write("M")
        assert_called @io_module.write("y")
        assert_called @io_module.write(" ")
        assert_called @io_module.write("m")
        assert_called @io_module.write("e")
        assert_called_exactly @io_module.write("s"), 2
        assert_called @io_module.write("a")
        assert_called @io_module.write("g")
        assert_called @io_module.write("e")
        assert_called_exactly @io_module.write("\n"), 2
      end
    end
  end

  describe "clear_screen/0" do
    test "calls system module cmd" do
      with_mock(
        @system_module,
        [
          cmd: fn("clear", [], _opts) -> :ok end
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.clear_screen() == :ok

        assert_called @system_module.cmd("clear", [], into: :_)
      end
    end
  end

  describe "print_message/1" do
    test "calls io module puts" do
      with_mock(
        @io_module,
        [
          puts: fn(message) -> message end
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.print_message("my msg") == "my msg"

        assert_called @io_module.puts("my msg")
      end
    end
  end

  describe "print_message/2" do
    test "calls io module write" do
      with_mock(
        @io_module,
        [
          write: fn(message) -> message end
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.print_message(
          "my msg", without_line_break: true
        ) == "my msg"

        assert_called @io_module.write("my msg")
      end
    end
  end

  describe "break_line/0" do
    test "calls io module write" do
      with_mock(
        @io_module,
        [
          write: fn("\n") -> "\n" end
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.break_line() == "\n"

        assert_called @io_module.write("\n")
      end
    end
  end

  describe "prompt_user_choice/1" do
    test "calls io module write and read" do
      with_mock(
        @io_module,
        [
          write: fn(message) -> message end,
          read: fn(:stdio, :line) -> "user's choice" end,
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.prompt_user_choice("What do you want to do?") ==
          "user's choice"

        assert_called @io_module.write("What do you want to do?: ")
        assert_called @io_module.read(:stdio, :line)
      end
    end
  end

  describe "wait_for_user_reading/0" do
    test "calls timer module sleep with configured user reading timer" do
      with_mock(
        @timer_module,
        [
          sleep: fn(sleep_time) -> sleep_time end,
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.wait_for_user_reading() == @user_reading_time

        assert_called @timer_module.sleep(@user_reading_time)
      end
    end
  end

  describe "wait_for_user_reading/1" do
    test "calls timer module sleep with custom timer" do
      with_mock(
        @timer_module,
        [
          sleep: fn(sleep_time) -> sleep_time end,
        ]
      ) do
        assert NasaExplorationRoversControlTerminalInterface.IO.wait_for_user_reading(1000) == 1000

        assert_called @timer_module.sleep(1000)
      end
    end
  end

end
