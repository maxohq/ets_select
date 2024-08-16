defmodule EtsSelect.MixProject do
  use Mix.Project
  @github_url "https://github.com/maxohq/ets_select"
  @version "0.1.0"
  @description "ETS match spec builder from a simple intuitive query language"

  def project do
    [
      app: :ets_select,
      source_url: @github_url,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_paths: ["lib"],
      test_pattern: "*_test.exs",
      description: @description
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README* CHANGELOG* LICENCE*),
      licenses: ["MIT"],
      links: %{
        "Github" => @github_url,
        "Changelog" => "#{@github_url}/blob/main/CHANGELOG.md"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:maxo_test_iex, "~> 0.1.7", only: :test},
      {:mneme, ">= 0.0.0", only: [:dev, :test]}
    ]
  end
end
