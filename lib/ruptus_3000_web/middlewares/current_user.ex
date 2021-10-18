defmodule Ruptus3000Web.Middlewares.CurrentUser do
  import Plug.Conn
  use Phoenix.Controller

  def init(options), do: options

  def call(conn, _key) do
    conn
    |> Map.put(:current_user, Pow.Plug.current_user(conn))
  end
end
