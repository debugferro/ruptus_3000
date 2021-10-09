defmodule Ruptus3000.Driver.FilterDrivers do
  @moduledoc """
    This handler filter drivers by checking if the delivery distance doesn't exceed the driver's vehicle
    maximum allowed range, or the maximum delivery time defined.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map(), map(), map()}
  def handle({:ok, driver, delivery_data, result}) do
    max_time = delivery_data["max_delivery_time"]
    case is_driver_valid?(driver, result, max_time) do
      true -> {:ok, driver, delivery_data, result}
      false -> {:error, "Tempo ou distância máxima ultrapassada", :no_drivers}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp is_driver_valid?(%{to_collect_point: %{duration: _}} = driver, result, max_time) do
    driver.total_distance <= result.vehicles[driver["vehicle"]][:max_range]
      and
    driver.total_time <= max_time
  end

  defp is_driver_valid?(driver, result, _max_time) do
    driver.to_collect_point.distance + result.to_delivery_point.distance
      <=
    result.vehicles[driver["vehicle"]][:max_range]
  end
end
