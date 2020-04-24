defmodule ElixirMobileWebGame.Core.Game do
  defstruct [:current_round, :players, :round_times, :id, :state, :start_time]

  alias ElixirMobileWebGame.Core.Player

  @max_rounds 2

  # @game_states [:pending, :started, :finished]

  def new(id),
    do: %__MODULE__{state: :pending, current_round: 0, players: %{}, round_times: [], id: id}

  def evaluate_game_state(%__MODULE__{state: :pending} = game), do: game
  def evaluate_game_state(%__MODULE__{state: :finished} = game), do: game

  def evaluate_game_state(%__MODULE__{state: :started} = game) do
    case Enum.all?(Map.values(game.players), fn player -> player.state == :finished end) do
      true ->
        {:ok, game} = __MODULE__.next_round(game)
        game

      false ->
        game
    end
  end

  def register_player(%__MODULE__{state: :pending} = game, player_id) do
    case Map.get(game.players, player_id) do
      %Player{} ->
        {:error, {game, player_id}}

      nil ->
        {:ok, %{game | players: Map.put(game.players, player_id, Player.new(player_id, game.id))}}
    end
  end

  def register_player(game, player_id), do: {:error, {game, player_id}}

  def player_click(%__MODULE__{state: :started} = game, player_id) do
    case Map.get(game.players, player_id) do
      %Player{} ->
        {:ok,
         __MODULE__.evaluate_game_state(%{
           game
           | players: Map.put(game.players, player_id, Player.click(game.players[player_id]))
         })}

      nil ->
        {:error, {game, player_id}}
    end
  end

  def player_click(game, player_id), do: {:error, {game, player_id}}

  def start(%__MODULE__{state: :pending} = game),
    do: {:ok, %{game | state: :started, start_time: DateTime.utc_now()}}

  def start(game), do: {:error, game}

  def next_round(%__MODULE__{state: :started, current_round: @max_rounds} = game),
    do: {:ok, %{game | state: :finished}}

  def next_round(%__MODULE__{state: :started} = game) do
    new_players =
      for {player_id, player} <- game.players, into: %{}, do: {player_id, Player.reset(player)}

    {:ok,
     %{
       game
       | current_round: game.current_round + 1,
         round_times: game.round_times ++ [DateTime.utc_now()],
         players: new_players
     }}
  end

  def next_round(game), do: {:error, game}

  def get_score(%__MODULE__{state: :started} = game),
    do:
      {:ok,
       DateTime.diff(
         DateTime.utc_now(),
         Enum.at(game.round_times, game.current_round - 1),
         :millisecond
       ) * 1000}

  def get_score(_), do: {:error, 0}
end
