defmodule ElixirMobileWebGame.PlayerTest do
  use ExUnit.Case, async: true
  alias ElixirMobileWebGame.Game
  alias ElixirMobileWebGame.Player

  test "Player can calculate their score with a game object in the right state" do
    game = Game.new("abcd") |> Game.start() |> Game.next_round()

    player = Player.new("test_id", game)

    player = Player.click(player)
    assert %Player{state: :finished} = player
    assert player.score != 0
  end
end
