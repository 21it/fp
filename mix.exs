defmodule Fp.MixProject do
  use Mix.Project

  def project do
    [
      app: :fp,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:mix_test_watch, "~> 1.0", only: [:test, :dev], runtime: false},
      {:propcheck, "~> 1.3", only: [:test, :dev]}
    ]
  end
end
