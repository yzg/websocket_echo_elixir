defmodule WebsocketEcho.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/ws", WebsocketEcho.SocketHandler, []}
      ]}
    ])

    children = [
      # Starts a worker by calling: WebsocketEcho.Worker.start_link(arg)

      # {WebsocketEcho.Worker, arg}


      %{
        id: :ws_http,
        start: {
          :cowboy, :start_clear, [
            :ws_listener,
            [port: 4000],
            %{env: %{dispatch: dispatch}}
          ]
        }
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebsocketEcho.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
