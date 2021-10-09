defmodule Ruptus3000.Driver.GetVehicles do
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Vehicle

  def handle({:ok, delivery_data, result}) do
    {:ok, delivery_data, get_vehicles(result)}
  end

  defp get_vehicles(result) do
    Map.put(result, :vehicles,
      build_vehicles_map(
        Vehicle.get_vehicles_by_max_range(result.to_delivery_point.distance)
      )
    )
  end

  defp build_vehicles_map(vehicles) do
    Enum.reduce(vehicles, %{}, fn vehicle, acc ->
      Map.put(acc, vehicle.label, %{
        max_range: vehicle.max_range,
        priority_range_start: vehicle.priority_range_start,
        priority_range_end: vehicle.priority_range_end
      })
    end)
    |> Map.put(:label_list, vehicles |> Vehicle.build_label_list())
  end
end
