defmodule ElixirMobileWebGame.GameTest do
  use ExUnit.Case, async: true
  # Can also take , as: ModuleAliasName
  alias ElixirMobileWebGame.Game

  test "end to end" do
    game = Game.new("abcd")

    {:ok, game} = Game.register_player(game, "abcd")

    assert %Game{state: :pending, current_round: 0, players: ["abcd"]} = game
    assert {:error, 0} = Game.get_score(game)
    assert {:error, %Game{state: :pending, current_round: 0}} = Game.next_round(game)

    {:ok, game} = Game.start(game)
    assert %Game{state: :started, current_round: 0} = game
    assert game.start_time != nil

    assert {:error, {%Game{state: :started, current_round: 0, players: ["abcd"]}, "efgh"}} =
             Game.register_player(game, "efgh")

    {:ok, game} = Game.next_round(game)
    assert %Game{state: :started, current_round: 1} = game

    {:ok, game} = Game.next_round(game)
    assert %Game{state: :started, current_round: 2} = game

    {:ok, game} = Game.next_round(game)
    assert %Game{state: :finished, current_round: 2} = game
  end
end
