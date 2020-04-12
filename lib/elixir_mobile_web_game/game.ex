defmodule ElixirMobileWebGame.Game do
  defstruct [:current_round, :id, :state, :start_time]

  @max_rounds 1

  # @game_states [:pending, :started, :finished]

  def new(id), do: %__MODULE__{state: :pending, current_round: 0, id: id}

  def start(%__MODULE__{state: :pending} = game),
    do: %{game | state: :started, start_time: DateTime.utc_now()}

  def start(game), do: game

  def next_round(%__MODULE__{state: :started, current_round: @max_rounds} = game),
    do: %{game | state: :finished}

  def next_round(%__MODULE__{state: :started} = game),
    do: %{game | current_round: game.current_round + 1}

  def next_round(game), do: game
end
