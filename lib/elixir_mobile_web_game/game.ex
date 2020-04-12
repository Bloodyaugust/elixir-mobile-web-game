defmodule ElixirMobileWebGame.Game do
  defstruct [:current_round, :players, :round_times, :id, :state, :start_time]

  @max_rounds 2

  # @game_states [:pending, :started, :finished]

  def new(id),
    do: %__MODULE__{state: :pending, current_round: 0, players: [], round_times: [], id: id}

  def register_player(%__MODULE__{state: :pending} = game, player_id),
    do: {:ok, %{game | players: [player_id | game.players]}}

  def register_player(game, player_id), do: {:error, {game, player_id}}

  def start(%__MODULE__{state: :pending} = game),
    do: {:ok, %{game | state: :started, start_time: DateTime.utc_now()}}

  def start(game), do: {:error, game}

  def next_round(%__MODULE__{state: :started, current_round: @max_rounds} = game),
    do: {:ok, %{game | state: :finished}}

  def next_round(%__MODULE__{state: :started} = game),
    do:
      {:ok,
       %{
         game
         | current_round: game.current_round + 1,
           round_times: game.round_times ++ [DateTime.utc_now()]
       }}

  def next_round(game), do: {:error, game}

  def get_score(%__MODULE__{state: :started} = game),
    do:
      {:ok,
       DateTime.diff(
         DateTime.utc_now(),
         Enum.at(game.round_times, game.current_round - 1),
         :millisecond
       )}

  def get_score(_), do: {:error, 0}
end
