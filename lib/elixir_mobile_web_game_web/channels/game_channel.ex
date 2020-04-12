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
      body: %{
        description: inspect(ElixirMobileWebGame.GameGenserver.get_state(game_genserver)),
        id: ElixirMobileWebGame.GameGenserver.get_state(game_genserver).id
      }
    })

    {:noreply, socket}
  end

  def handle_in("start:" <> game_id, %{"body" => _body}, socket) do
    ElixirMobileWebGame.GameGenserver.start_game(game_id)

    {:noreply, socket}
  end

  def handle_in("next_round:" <> game_id, %{"body" => _body}, socket) do
    broadcast!(socket, "new-round", %{
      body: inspect(ElixirMobileWebGame.GameGenserver.next_round(game_id))
    })

    {:noreply, socket}
  end
end
