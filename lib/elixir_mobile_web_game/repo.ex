defmodule ElixirMobileWebGame.Repo do
  use Ecto.Repo,
    otp_app: :elixir_mobile_web_game,
    adapter: Ecto.Adapters.Postgres
end
