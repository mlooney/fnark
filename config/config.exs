# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fnark,
  ecto_repos: [Fnark.Repo]

# Configures the endpoint
config :fnark, Fnark.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dF2/QlKgZkm+jpaFc+mzenHl0RjlzkqHbCpuEU1FSmoWo8ju6fJucBaN/b8XeNTm",
  render_errors: [view: Fnark.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fnark.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  verify_module: Guardian.JWT,
  issuer: "Fnark",
  ttl: {365, :days},
  verify_issuer: true,
  serializer: Fnark.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

