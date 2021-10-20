defmodule Ruptus3000.Routing.BuildResponse do
  @moduledoc """
    This handler build the final response with joined polylines.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, delivery_data, result}) do
    {:ok, delivery_data, build_response_map(result, delivery_data)}
  end

  def handle(error), do: error

  defp build_response_map(%{selected_driver: driver} = result, delivery_data) do
    Map.put(result, :result,
    %{
      selected_driver: %{
        id: driver["id"],
        full_name: driver["full_name"],
        localization: driver["localization"]
      },
      route: %{
        to_collect_point: build_collect_point(driver.to_collect_point, delivery_data),
        to_delivery_point: build_delivery_point(result.to_delivery_point, delivery_data),
        full_route: %{
          distance: driver.total_distance,
          duration: driver.total_time,
          polyline: build_polyline(driver .to_collect_point.polyline, result.to_delivery_point.polyline)
        }
      }
    })
  end

  defp build_polyline(collect_polyline, delivery_polyline) do
    Polyline.encode(Polyline.decode(collect_polyline) ++ Polyline.decode(delivery_polyline))
  end

  defp build_collect_point(collect_point, %{"collect_point" => %{"localization" => localization}}) do
    Map.put(collect_point, :localization, localization)
  end

  defp build_delivery_point(delivery_point, %{"delivery_point" => %{"localization" => localization}}) do
    Map.put(delivery_point, :localization, localization)
  end
end
