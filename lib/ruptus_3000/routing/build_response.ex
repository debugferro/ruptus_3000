defmodule Ruptus3000.Routing.BuildResponse do
  @moduledoc """
    This handler returns the fastest driver to be responsible for a delivery.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, driver, result}) do
    {:ok, %{
      delivery_person: %{
        id: driver["id"],
        full_name: driver["full_name"]
      },
      route: %{
        to_collect_point: driver.to_collect_point,
        to_delivery_point: result.to_delivery_point,
        full_route: %{
          distance: driver.total_distance,
          duration: driver.total_time,
          polyline: build_polyline(driver.to_collect_point.polyline, result.to_delivery_point.polyline)
        }
      }
    }}
  end

  def handle(error), do: error

  defp build_polyline(collect_polyline, delivery_polyline) do
    Polyline.encode(Polyline.decode(collect_polyline) ++ Polyline.decode(delivery_polyline))
  end
end
