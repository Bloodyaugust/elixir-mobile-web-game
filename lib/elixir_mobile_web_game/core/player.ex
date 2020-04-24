defmodule ElixirMobileWebGame.Core.Player do
  defstruct [:score, :id, :state, :game_id]

  alias ElixirMobileWebGame.Boundary.GameGenserver

  # @player_states [:waiting, :finished]

  def new(id, game_id),
    do: %__MODULE__{
      state: :waiting,
      score: 0,
      game_id: game_id,
      id: id
    }

  def click(%__MODULE__{state: :waiting} = player) do
    %{
      player
      | state: :finished,
        score:
          player.score +
            GameGenserver.get_score(player.game_id)
    }
  end

  def click(player), do: player

  def reset(%__MODULE__{state: :finished} = player), do: %{player | state: :waiting}
  def reset(player), do: player
end
