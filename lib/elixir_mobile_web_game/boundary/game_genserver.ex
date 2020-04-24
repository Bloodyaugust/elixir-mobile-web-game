defmodule ElixirMobileWebGame.Boundary.GameGenserver do
  use GenServer

  alias ElixirMobileWebGame.Core.Game
  alias ElixirMobileWebGame.Core.Util

  def start_link(id) when is_bitstring(id) do
    name = via_tuple(id)
    ElixirMobileWebGameWeb.Endpoint.broadcast("game:all", "creating", %{body: id})
    GenServer.start_link(__MODULE__, Game.new(id), name: name)
  end

  def start_link() do
    id = Util.random_string(4)
    name = via_tuple(id)
    ElixirMobileWebGameWeb.Endpoint.broadcast("game:all", "creating", %{body: id})
    GenServer.start_link(__MODULE__, Game.new(id), name: name)
  end

  def click(game_id, player_id) when is_bitstring(game_id) do
    GenServer.call(via_tuple(game_id), {:click, player_id})
  end

  def register_player(game_id, player_id) when is_bitstring(game_id) do
    GenServer.call(via_tuple(game_id), {:register_player, player_id})
  end

  def get_score(game_id) when is_bitstring(game_id) do
    GenServer.call(via_tuple(game_id), :get_score)
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

  def handle_call(:get_score, _from, game) do
    {_, score} = Game.get_score(game)
    {:reply, score, game}
  end

  def handle_call(:get_state, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:click, player_id}, _from, game) do
    {_, game} = Game.player_click(game, player_id)
    {:reply, game, game}
  end

  def handle_call({:register_player, player_id}, _from, game) do
    {_, game} = Game.register_player(game, player_id)
    {:reply, game, game}
  end

  def handle_call(:start, _from, game) do
    {_, game} = Game.start(game)
    {:reply, game, game}
  end

  def handle_call(:next_round, _from, game) do
    {_, game} = Game.next_round(game)
    {:reply, game, game}
  end

  defp via_tuple(game_id) do
    {:via, Registry, {Registry.Game, game_id}}
  end
end
