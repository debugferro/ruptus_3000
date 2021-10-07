defmodule Ruptus3000Web.Api.V1.DeliveryController do
  use Ruptus3000Web, :controller

  alias Ruptus3000.Driver.Selector

  def route(conn, params) do
    case Selector.start(params) |> IO.inspect(label: "result") do
      {:ok, driver} -> render(conn, "route.json", %{result: driver})
      {:error, message, status} -> render(conn, "route.json", %{result: %{message: message, error_type: "#{status}"}})
      {:error, status} -> render(conn, "route.json", %{result: %{message: "An error occured", error_type: "#{status}"}})
    end
  end
end
