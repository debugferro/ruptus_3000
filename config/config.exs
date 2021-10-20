# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ruptus_3000,
  ecto_repos: [Ruptus3000.Repo]

# Configures the endpoint
config :ruptus_3000, Ruptus3000Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OHWXMEOFud7Tvss+M44Md+av6jdm55jUTZkcTaPyCZq5RukMtEm2x2Kto8OBuZm6",
  render_errors: [view: Ruptus3000Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ruptus3000.PubSub,
  live_view: [signing_salt: "53YlhyzJ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ruptus_3000, Ruptus3000.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ruptus_3000, :pow,
  user: Ruptus3000.Users.User,
  repo: Ruptus3000.Repo,
  web_module: Ruptus3000Web

config :ruptus_3000, routing_api_key: System.get_env("ROUTING_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
