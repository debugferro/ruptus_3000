defmodule Ruptus3000Web.Middlewares.ApiAuthentication do
  import Plug.Conn
  use Phoenix.Controller

  alias Ruptus3000.Token

  def init(options), do: options

  def call(conn, _key) do
    case Token.check_validity(conn.params["api_key"] || nil) do
      :authorized -> conn
      :not_authorized ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error_type: "not_authorized", message: "You are not authorized. Please, check your API key."})
        |> halt()
    end
  end
end
