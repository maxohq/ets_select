defmodule EtsSelect.MixProject do
  use Mix.Project

  def project do
    [
      app: :ets_select,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_paths: ["lib"],
      test_pattern: "*_test.exs"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:maxo_test_iex, "~> 0.1.7", only: :test},
      {:mneme, ">= 0.0.0", only: [:dev, :test]}
    ]
  end
end
