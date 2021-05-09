defmodule NASAExplorationRoversControl.MixProject do
  use Mix.Project

  def project do
    [
      app: :nasa_exploration_rovers_control,
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "NASA Exploration Rovers Control",
      source_url: "https://github.com/williamweckl/nasa_exploration_rovers_control",
      homepage_url: "https://github.com/williamweckl/nasa_exploration_rovers_control",
      docs: [
        main: "NASA Exploration Rovers Control", # The main page in the docs
        extras: ["README.md"]
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false}
    ]
  end
end
