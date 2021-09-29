defmodule Ruptus3000Web.Api.V1.DeliveryController do
  use Ruptus3000Web, :controller

  def route(conn, _params) do
    render(conn, "route.json", %{id: 1})
  end
end
