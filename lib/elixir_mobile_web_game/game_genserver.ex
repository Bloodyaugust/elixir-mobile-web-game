defmodule ElixirMobileWebGame.GameGenserver do
  use GenServer

  alias ElixirMobileWebGame.Game
  alias ElixirMobileWebGame.Util

  def start_link() do
    id = Util.random_string(4)
    name = via_tuple(id)
    ElixirMobileWebGameWeb.Endpoint.broadcast("game:all", "creating", %{body: id})
    GenServer.start_link(ElixirMobileWebGame.GameGenserver, Game.new(id), name: name)
  end

  def get_state(game_id) when is_bitstring(game_id) do
    GenServer.call(via_tuple(game_id), :get_state)
  end

  def get_state(game_genserver) do
    GenServer.call(game_genserver, :get_state)
  end

  def start_game(game_id) do
    result = GenServer.call(via_tuple(game_id), :start)

    ElixirMobileWebGameWeb.Endpoint.broadcast("game:#{game_id}", "updated", %{
      body: %{id: game_id, state: inspect(get_state(game_id))}
    })

    result
  end

  def next_round(game_id) do
    result = GenServer.call(via_tuple(game_id), :next_round)

    ElixirMobileWebGameWeb.Endpoint.broadcast("game:#{game_id}", "updated", %{
      body: %{id: game_id, state: inspect(get_state(game_id))}
    })

    result
  end

  def init(game) do
    {:ok, game}
  end

  def handle_call(:get_state, _from, game) do
    {:reply, game, game}
  end

  def handle_call(:start, _from, game) do
    game = Game.start(game)
    {:reply, game, game}
  end

  def handle_call(:next_round, _from, game) do
    game = Game.next_round(game)
    {:reply, game, game}
  end

  defp via_tuple(game_id) do
    {:via, Registry, {Registry.Game, game_id}}
  end
end
