defmodule ElixirMobileWebGameWeb.GameChannel do
  use Phoenix.Channel

  def join("game:all", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> _game_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("create", %{"body" => _body}, socket) do
    {:ok, game_genserver} = ElixirMobileWebGame.GameDynamicSupervisor.start_child()

    broadcast!(socket, "created", %{
      body: inspect(ElixirMobileWebGame.GameGenserver.get_state(game_genserver))
    })

    {:noreply, socket}
  end

  def handle_in("creating", %{"body" => body}, socket) do
    broadcast!(socket, "creating", %{
      body: body
    })

    {:noreply, socket}
  end

  def handle_in("start:" <> game_id, %{"body" => _body}, socket) do
    broadcast!(socket, "started", %{
      body: inspect(ElixirMobileWebGame.GameGenserver.start_game(game_id))
    })

    {:noreply, socket}
  end
end
