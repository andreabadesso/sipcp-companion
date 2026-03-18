defmodule SipcpCompanion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SipcpCompanionWeb.Telemetry,
      SipcpCompanion.Repo,
      {DNSCluster, query: Application.get_env(:sipcp_companion, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SipcpCompanion.PubSub},
      # Local embeddings model (Bumblebee + EXLA)
      {Nx.Serving,
       serving: SipcpCompanion.AI.Embeddings.serving(),
       name: SipcpCompanion.EmbeddingServing,
       batch_timeout: 100},
      # Agent registry — each conversation session is a GenServer
      {Registry, keys: :unique, name: SipcpCompanion.AgentRegistry},
      # Start to serve requests, typically the last entry
      SipcpCompanionWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SipcpCompanion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SipcpCompanionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
