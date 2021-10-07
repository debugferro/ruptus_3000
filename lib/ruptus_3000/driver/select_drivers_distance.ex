defmodule Ruptus3000.Driver.SelectDriversDistance do
  @moduledoc """
      This handler is reponsible for returning all drivers that have a vehicle
      with a max range greater than or equal to the delivery distance.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Vehicle
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, delivery_data, result}) do
    vehicles = Vehicle.get_vehicles_by_max_range(result.to_delivery_point.distance)
    drivers = select_drivers(delivery_data["drivers"], vehicles)

    case drivers do
      [] -> {:error, "Não há entregadores disponíveis.", :no_delivery_person}
      _ -> {:ok, delivery_data, build_return(drivers, vehicles, result)}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp select_drivers(drivers, vehicles) do
    vehicle_labels =
      vehicles
      |> Vehicle.build_label_list()

    Enum.filter(drivers, fn driver ->
      Enum.member?(vehicle_labels, driver["vehicle"])
    end)
  end

  defp build_return(drivers, vehicles, result) do
    Map.put(result, :drivers, drivers)
    |> Map.put(:vehicles, build_vehicles_map(vehicles))
  end

  defp build_vehicles_map(vehicles) do
    Enum.reduce(vehicles, %{}, fn vehicle, acc ->
      Map.put(acc, vehicle.label, %{
        max_range: vehicle.max_range,
        priority_range_start: vehicle.priority_range_start,
        priority_range_end: vehicle.priority_range_end
      })
    end)
  end
end
