defmodule Ruptus3000.Driver.GetDeliveryPath do
  @moduledoc """
    This handle is responsible for returning the distance, time and polyline
    from the collect point to the delivery point, which is a common path for all delivery persons.

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

  @behaviour Ruptus3000.Driver.Handler
  alias Ruptus3000.Services.GoogleApi
  @spec handle(%{optional(String.t) => any()}) :: {:error, atom} | {:error, String.t(), atom()} | {:ok, map(), map()}

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
