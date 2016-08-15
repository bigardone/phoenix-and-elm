# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_and_elm,
  ecto_repos: [PhoenixAndElm.Repo]

# Configures the endpoint
config :phoenix_and_elm, PhoenixAndElm.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "baoYW6OO9jbiR6e2tXURKD5ZqGyFiDThb03xFgbzyOrcp4s9ZDjkeSkb9pNJQhzq",
  render_errors: [view: PhoenixAndElm.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixAndElm.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
