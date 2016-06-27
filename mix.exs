defmodule Slacker.Mixfile do
  use Mix.Project

  @version "0.0.3"

  def project do
    [app: :slacker,
     version: @version,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env),
     description: "A bot library for the Slack chat service.",
     package: package]
  end

  def application do
    [applications: [:logger, :httpoison, :poison, :crypto, :ssl, :websocket_client]]
  end

  defp deps(:test) do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 0.12"}] ++ deps(:prod)
  end

  defp deps(_env) do
    [{:websocket_client, github: "jeremyong/websocket_client"},
     {:httpoison, "~> 0.9"},
     {:poison, "~> 1.4"},
     {:inflex, "~> 1.0.0"}]
  end

  defp package do
    [maintainers: ["Michael Shapiro"],
     licenses: ["MIT"],
     links: %{"GitHub": "https://github.com/koudelka/slacker",
              "Slack": "https://api.slack.com"}]
  end
end
