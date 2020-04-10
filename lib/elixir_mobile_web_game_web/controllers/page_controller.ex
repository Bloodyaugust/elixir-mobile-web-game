defmodule ElixirMobileWebGameWeb.PageController do
  use ElixirMobileWebGameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
