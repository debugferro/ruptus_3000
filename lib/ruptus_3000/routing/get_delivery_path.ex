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
  alias Ruptus3000.Routing.Helpers
  alias Ruptus3000.Types.Error

  @spec handle(%{optional(String.t()) => any()}) ::
          {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:error, message}), do: {:error, message}

  def handle(delivery_data) do
    with {:ok, collect_point} <-
           Helpers.checkpoint_validity(delivery_data, :collect) |> check_response(),
         {:ok, delivery_point} <-
           Helpers.checkpoint_validity(delivery_data, :delivery) |> check_response(),
         {:ok, route_response} <- GoogleApi.request_route(collect_point, delivery_point) do
      build_return(route_response, delivery_data)
    else
      error -> error
    end
  end

  defp check_response({:ok, response}), do: {:ok, response}
  defp check_response({:error, key}), do: {:error, payload_error_msg(key), :invalid_payload}

  defp payload_error_msg(key),
    do: "You need to provide a " <> key <> " with localization, latitude, longitude"

  defp build_response(response) do
    %{
      to_delivery_point: GoogleApi.filter_response(response)
    }
  end

  defp build_return(response, delivery_data), do: {:ok, delivery_data, build_response(response)}
end
