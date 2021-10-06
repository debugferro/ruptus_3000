defmodule Ruptus3000.Driver.CheckPriority do
  @moduledoc """
    This handler adds a priority atom to each driver, and assigns its value to either
    true or false.
  """
  @behaviour Ruptus3000.Driver.Handler
  @spec handle({:ok, map(), map()}) ::
          {:error, atom} | {:error, String.t(), atom()} | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    {:ok, delivery_data, Map.put(result, :delivery_people, check_priority(result))}
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp check_priority(result) do
    Enum.map(result.delivery_people, fn driver ->
      total_distance = driver.to_collect_point.distance + result.to_delivery_point.distance

      Map.put(
        driver,
        :priority,
        has_priority?(result.vehicles[driver["vehicle"]], total_distance)
      )
    end)
  end

  defp has_priority?(vehicle, total_distance),
    do: vehicle.priority_start <= total_distance and vehicle.priority_end >= total_distance
end
