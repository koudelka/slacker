use Mix.Config

config :logger, :console,
  format: "\n$date $time [$level] [Slacker] $metadata$message"

if File.exists?("config/#{Mix.env}.exs"), do: import_config "#{Mix.env}.exs"
