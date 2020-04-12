defmodule ElixirMobileWebGame.Player do
  defstruct [:score, :id, :state, :game]

  # @player_states [:waiting, :finished]

  def new(id, game),
    do: %__MODULE__{
      state: :waiting,
      score: 0,
      game: game,
      id: id
    }

  def click(%__MODULE__{state: :waiting} = player) do
    %{
      player
      | state: :finished,
        score:
          player.score +
            ElixirMobileWebGame.Game.get_score(player.game)
    }
  end

  def click(player), do: player

  def reset(%__MODULE__{state: :finished} = player), do: %{player | state: :waiting}
  def reset(player), do: player
end
