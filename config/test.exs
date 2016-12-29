use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fnark, Fnark.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :fnark, Fnark.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "fnark_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
  secret_key: "d+WQzyF/XDUQ8YWfYGGueDwtxHMPtM6FJgo3LY9BWGT2yWQAzdQ4+iEM9acQ5Vtw"
