defmodule MayhemChatbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :mayhem_chatbot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MayhemChatbot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.30.0"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      {:jason, ">= 1.0.0"},
      {:dotenv_parser, "~> 1.2"}
    ]
  end
end
