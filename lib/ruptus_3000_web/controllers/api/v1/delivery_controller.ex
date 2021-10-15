defmodule Ruptus3000Web.Api.V1.DeliveryController do
  use Ruptus3000Web, :controller
  alias Ruptus3000.Routing.HandleRouting
  plug Ruptus3000.Data.Payload, :validate when action in [:route]

  def route(conn, params) do
    case HandleRouting.start(params) do
      {:ok, driver} -> render(conn, "route.json", %{result: driver})
      {:error, message, status} -> render(conn, "route.json", %{result: %{message: message, error_type: "#{status}"}})
      {:error, status} -> render(conn, "route.json", %{result: %{message: "An error occured", error_type: "#{status}"}})
    end
  end
end
