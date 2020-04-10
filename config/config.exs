# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_mobile_web_game,
  ecto_repos: [ElixirMobileWebGame.Repo]

# Configures the endpoint
config :elixir_mobile_web_game, ElixirMobileWebGameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fnXlI/rjwWk35YbEGsMju0CsCGeWLY6VYEL9KDLrXZZaBaK/u5l9rxEMMV6jyv+b",
  render_errors: [view: ElixirMobileWebGameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirMobileWebGame.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "U8AME0kS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
