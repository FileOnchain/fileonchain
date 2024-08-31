defmodule Fileonchain.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FileonchainWeb.Telemetry,
      Fileonchain.Repo,
      {DNSCluster, query: Application.get_env(:fileonchain, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fileonchain.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Fileonchain.Finch},
      # Start a worker by calling: Fileonchain.Worker.start_link(arg)
      # {Fileonchain.Worker, arg},
      # Start to serve requests, typically the last entry
      FileonchainWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fileonchain.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FileonchainWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
