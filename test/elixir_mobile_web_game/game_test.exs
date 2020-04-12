defmodule ElixirMobileWebGame.GameTest do
  use ExUnit.Case, async: true
  # Can also take , as: ModuleAliasName
  alias ElixirMobileWebGame.Game

  test "new games are pending at 0 rounds" do
    assert %Game{state: :pending, current_round: 0} = Game.new("abcd")
  end

  test "games that are pending can be started" do
    game = Game.new("abcd") |> Game.start()
    assert %Game{state: :started, current_round: 0} = game
    assert game.start_time != nil
  end

  test "games that are started can be advanced in rounds" do
    assert %Game{state: :started, current_round: 1} =
             Game.new("abcd")
             |> Game.start()
             |> Game.next_round()
  end

  test "games can provide a score based on time difference" do
    game = Game.new("abcd") |> Game.start() |> Game.next_round()
    assert length(game.round_times) > 0
    assert Game.get_score(game) != nil
  end

  test "games that have hit @max_rounds are finished when next_round is called" do
    assert %Game{state: :finished, current_round: 2} =
             Game.new("abcd")
             |> Game.start()
             |> Game.next_round()
             |> Game.next_round()
             |> Game.next_round()
  end

  test "end to end" do
    game = Game.new("abcd")

    assert %Game{state: :pending, current_round: 0} = game

    game = Game.start(game)
    assert %Game{state: :started, current_round: 0} = game
    assert game.start_time != nil

    game = Game.next_round(game)
    assert %Game{state: :started, current_round: 1} = game

    game = Game.next_round(game)
    assert %Game{state: :started, current_round: 2} = game

    game = Game.next_round(game)
    assert %Game{state: :finished, current_round: 2} = game
  end
end
