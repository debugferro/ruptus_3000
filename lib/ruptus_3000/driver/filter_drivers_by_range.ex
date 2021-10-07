defmodule Ruptus3000.Driver.FilterDriversByRange do
  @moduledoc """
    This handler filter drivers by adding each driver's collect distance (straight line)
    and the previously routed delivery distance, then comparing it with the driver's vehicle
    maximum allowed range.
  """
  @behaviour Ruptus3000.Driver.Handler

  @spec handle({:ok, map(), map()}) ::
          {:error, atom} | {:error, String.t(), atom()} | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do

    case filter_drivers_by_range(result, delivery_data["max_delivery_time"]) do
      [] -> {:error, "Não há entregadores disponíveis.", :no_delivery_person}
      drivers -> {:ok, delivery_data, Map.put(result, :delivery_people, drivers)}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp filter_drivers_by_range(%{delivery_people: [%{to_collect_point: %{duration: _}} | _]} = result, max_time) do
    Enum.filter(result.delivery_people, fn driver ->
      driver.total_distance
      <=
      result.vehicles[driver["vehicle"]][:max_range]
      and
      driver.total_time
      <= max_time
    end)
  end

  defp filter_drivers_by_range(result, _max_delivery_time) do
    Enum.filter(result.delivery_people, fn driver ->
      driver.to_collect_point.distance + result.to_delivery_point.distance <=
        result.vehicles[driver["vehicle"]][:max_range]
    end)
  end
end
