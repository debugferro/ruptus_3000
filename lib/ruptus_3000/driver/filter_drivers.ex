defmodule Ruptus3000.Driver.FilterDrivers do
  @moduledoc """
    This handler filter drivers by checking if the delivery distance doesn't exceed the driver's vehicle
    maximum allowed range, or the maximum delivery time defined.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do

    case filter_drivers_by_range(result, delivery_data["max_delivery_time"]) do
      [] -> {:error, "Não há entregadores disponíveis.", :no_drivers}
      drivers -> {:ok, delivery_data, Map.put(result, :drivers, drivers)}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp filter_drivers_by_range(%{drivers: [%{to_collect_point: %{duration: _}} | _]} = result, max_time) do
    Enum.filter(result.drivers, fn driver ->
      driver.total_distance
      <=
      result.vehicles[driver["vehicle"]][:max_range]
      and
      driver.total_time
      <= max_time
    end)
  end

  defp filter_drivers_by_range(result, _max_delivery_time) do
    Enum.filter(result.drivers, fn driver ->
      driver.to_collect_point.distance + result.to_delivery_point.distance <=
        result.vehicles[driver["vehicle"]][:max_range]
    end)
  end
end
