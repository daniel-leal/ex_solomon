defmodule ExSolomon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExSolomonWeb.Telemetry,
      ExSolomon.Repo,
      {DNSCluster,
       query: Application.get_env(:ex_solomon, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExSolomon.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExSolomon.Finch},
      # Start a worker by calling: ExSolomon.Worker.start_link(arg)
      # {ExSolomon.Worker, arg},
      # Start to serve requests, typically the last entry
      ExSolomonWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExSolomon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExSolomonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
