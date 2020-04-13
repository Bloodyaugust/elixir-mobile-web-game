defmodule ElixirMobileWebGame.PlayerTest do
  use ExUnit.Case, async: false
  alias ElixirMobileWebGame.GameGenserver
  alias ElixirMobileWebGame.Player

  test "Player can calculate their score with a game object in the right state" do
    # Why/how is the Registry (Registry.Game) already started here?
    {:ok, _} = GameGenserver.start_link("abcd")

    GameGenserver.start_game("abcd")
    GameGenserver.next_round("abcd")

    player = Player.new("test_id", "abcd")

    :timer.sleep(1)

    player = Player.click(player)
    assert %Player{state: :finished} = player
    assert player.score > 0
  end
end
