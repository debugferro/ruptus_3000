defmodule Ruptus3000Web.Api.V1.DeliveryController do
  use Ruptus3000Web, :controller

  alias Ruptus3000.Driver.Selector

  def route(conn, params) do
    case Selector.start(params) do
      {:ok, driver} -> render(conn, "route.json", %{result: driver})
      {:error, message, _status} -> render(conn, "route.json", %{error: message})
      {:error, status} -> render(conn, "route.json", %{status: status})
    end
  end
end
