defmodule ElixirMobileWebGame.Game do
  defstruct [:current_round, :round_times, :id, :state, :start_time]

  @max_rounds 2

  # @game_states [:pending, :started, :finished]

  def new(id), do: %__MODULE__{state: :pending, current_round: 0, round_times: [], id: id}

  def start(%__MODULE__{state: :pending} = game),
    do: %{game | state: :started, start_time: DateTime.utc_now()}

  def start(game), do: game

  def next_round(%__MODULE__{state: :started, current_round: @max_rounds} = game),
    do: %{game | state: :finished}

  def next_round(%__MODULE__{state: :started} = game),
    do: %{
      game
      | current_round: game.current_round + 1,
        round_times: game.round_times ++ [DateTime.utc_now()]
    }

  def next_round(game), do: game

  def get_score(%__MODULE__{state: :started} = game),
    do:
      DateTime.diff(
        DateTime.utc_now(),
        Enum.at(game.round_times, game.current_round - 1),
        :millisecond
      )

  def get_score(game), do: {:error, game}
end
