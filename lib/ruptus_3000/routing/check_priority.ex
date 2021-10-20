defmodule Ruptus3000.Routing.CheckPriority do
  @moduledoc """
    This handler adds a priority atom to each driver, and assigns its value to either
    true or false.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map()}
  def handle({:ok, delivery_data, result}) do
    {:ok, delivery_data, Map.put(result, :drivers, check_priority(result))}
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp check_priority(result) do
    Enum.filter(result.drivers, fn driver ->
      total_distance = driver.to_collect_point.distance + result.to_delivery_point.distance

      has_priority?(result.vehicles[driver["vehicle"]], total_distance)
    end)
    |> return_drivers(result)
  end

  defp return_drivers(filtered, _non_filtered) when length(filtered) >= 1, do: filtered
  defp return_drivers(_filtered, non_filtered), do: non_filtered

  defp has_priority?(vehicle, total_distance),
    do: vehicle.priority_range_start <= total_distance and vehicle.priority_range_end >= total_distance
end
