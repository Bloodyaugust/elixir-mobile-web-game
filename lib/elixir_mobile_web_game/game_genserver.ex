defmodule ElixirMobileWebGame.GameGenserver do
  use GenServer

  alias ElixirMobileWebGame.Game

  def start_link() do
    GenServer.start_link(ElixirMobileWebGame.GameGenserver, Game.new())
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def start_game(pid) do
    GenServer.call(pid, :start)
  end

  def next_round(pid) do
    GenServer.call(pid, :next_round)
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
end
