use Mix.Config

config :nasa_exploration_rovers_control, NasaExplorationRoversControlTerminalInterface,
  typing_effect_print_time: 0,
  user_reading_time: 0,
  io_module: FakeIO,
  timer_module: FakeTimer,
  system_module: FakeSystem
