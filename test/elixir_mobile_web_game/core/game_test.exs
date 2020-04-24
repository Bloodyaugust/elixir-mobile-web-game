defmodule ElixirMobileWebGame.Core.GameTest do
  use ExUnit.Case, async: false
  # Can also take , as: ModuleAliasName
  alias ElixirMobileWebGame.Core.Game
  alias ElixirMobileWebGame.Boundary.GameGenserver
  alias ElixirMobileWebGame.Core.Player

  test "end to end" do
    {:ok, _} = GameGenserver.start_link("abcd")
    game = GameGenserver.get_state("abcd")

    {:ok, game} = Game.register_player(game, "player_1")
    {:ok, game} = Game.register_player(game, "player_2")

    assert %Game{
             state: :pending,
             current_round: 0,
             players: %{"player_1" => %Player{id: "player_1", game_id: "abcd"}}
           } = game

    assert {:error, 0} = Game.get_score(game)
    assert {:error, %Game{state: :pending, current_round: 0}} = Game.next_round(game)

    {:ok, game} = Game.start(game)
    assert %Game{state: :started, current_round: 0} = game
    assert game.start_time != nil

    assert {:error,
            {%Game{
               state: :started,
               current_round: 0,
               players: %{"player_1" => %Player{id: "player_1", game_id: "abcd"}}
             }, "efgh"}} = Game.register_player(game, "efgh")

    {:ok, game} = Game.next_round(game)
    assert %Game{state: :started, current_round: 1} = game
    assert length(game.round_times) > 0

    {:ok, game} = Game.player_click(game, "player_1")
    assert %Game{players: %{"player_1" => %Player{state: :finished}}} = game

    {:ok, game} = Game.player_click(game, "player_2")
    assert %Game{players: %{"player_2" => %Player{state: :waiting}}} = game

    {:ok, game} = Game.player_click(game, "player_1")
    {:ok, game} = Game.player_click(game, "player_2")

    assert %Game{state: :finished, current_round: 2} = game
  end
end
