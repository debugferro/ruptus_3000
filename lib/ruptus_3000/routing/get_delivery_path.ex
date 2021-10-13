defmodule Ruptus3000.Routing.GetDeliveryPath do
  @moduledoc """
    This handler is responsible for returning the route's distance, time and polyline,
    from the collect point to the delivery point, which is a common route for all drivers.

    It receives a map with the following information:
    %{ "collect_point" =>
      %{
        "localization" => %{ "latitude" => lat, "longitude" => long }
      },
      "delivery_point" =>
      %{
        "localization" => %{ "latitude" => lat, "longitude" => long }
      }
    }
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.Types.Error

  @spec handle(%{optional(String.t()) => any()}) ::
    {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle(delivery_data) do
    collect_point = delivery_data["collect_point"]["localization"]
    delivery_point = delivery_data["delivery_point"]["localization"]

    case GoogleApi.request_route(collect_point, delivery_point) do
      {:ok, route_response} -> build_return(route_response, delivery_data)
      {:error, message, status} -> {:error, message, status}
      {:error, status} -> {:error, status}
    end
  end

  defp build_response(response) do
    %{
      to_delivery_point: GoogleApi.filter_response(response)
    }
  end

  defp build_return(response, delivery_data), do: {:ok, delivery_data, build_response(response)}
end
