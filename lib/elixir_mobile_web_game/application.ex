defmodule ElixirMobileWebGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      ElixirMobileWebGame.Repo,
      # Start the endpoint when the application starts
      ElixirMobileWebGameWeb.Endpoint,
      # Starts a worker by calling: ElixirMobileWebGame.Worker.start_link(arg)
      # {ElixirMobileWebGame.Worker, arg},
      ElixirMobileWebGame.Boundary.GameDynamicSupervisor,
      {Registry, keys: :unique, name: Registry.Game}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMobileWebGame.Supervisor]
    Supervisor.start_link(children, opts)

    Enum.each(0..9, fn _ -> ElixirMobileWebGame.Boundary.GameDynamicSupervisor.start_child() end)

    {:ok, self()}
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirMobileWebGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
