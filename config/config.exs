# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :nasa_exploration_rovers_control, NasaExplorationRoversControlTerminalInterface,
  typing_effect_print_time: 30,
  user_reading_time: 2000,
  io_module: IO,
  file_module: File,
  timer_module: :timer,
  system_module: System

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
