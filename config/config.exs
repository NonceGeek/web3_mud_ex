# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :web3_mud_ex,
  namespace: Web,
  ecto_repos: [Web3MUDEx.Repo]

config :web3_mud_ex, :listener, start: true

# Configures the endpoint
config :web3_mud_ex, Web.Endpoint,
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub_server: Web3MUDEx.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :porcelain, driver: Porcelain.Driver.Basic

if File.exists?("config/#{Mix.env()}.exs") do
  import_config "#{Mix.env()}.exs"
end
