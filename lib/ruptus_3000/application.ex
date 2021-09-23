defmodule Ruptus3000.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ruptus3000.Repo,
      # Start the Telemetry supervisor
      Ruptus3000Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ruptus3000.PubSub},
      # Start the Endpoint (http/https)
      Ruptus3000Web.Endpoint
      # Start a worker by calling: Ruptus3000.Worker.start_link(arg)
      # {Ruptus3000.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ruptus3000.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Ruptus3000Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
