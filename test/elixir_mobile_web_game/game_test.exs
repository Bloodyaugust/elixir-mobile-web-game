defmodule ElixirMobileWebGame.GameTest do
  use ExUnit.Case, async: true
  alias ElixirMobileWebGame.Game # Can also take , as: ModuleAliasName

  test "new games are pending at 0 rounds" do
    assert %Game{state: :pending, current_round: 0} = Game.new()
  end

  test "games that are pending can be started" do
    game = Game.new() |> Game.start()
    assert %Game{state: :started, current_round: 0} = game
    assert game.start_time != nil
  end

  test "games that are started can be advanced in rounds" do
    assert %Game{state: :started, current_round: 1} = Game.new() |> Game.start() |> Game.next_round()
  end

  test "games that have hit @max_rounds are finished when next_round is called" do
    assert %Game{state: :finished, current_round: 1} = Game.new() |> Game.start() |> Game.next_round() |> Game.next_round()
  end
end