defmodule Ruptus3000.Driver.Filter do
  @moduledoc """
    This handler filter driver by checking if the delivery distance doesn't exceed the driver's vehicle
    maximum allowed range, or the maximum delivery time defined.
  """
  @behaviour Ruptus3000.Driver.Behaviour.Handler
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.Behaviour.Handler

  @spec handle(Handler.payload() | Error.basic_tuple() | Error.detailed_tuple()) ::
    Handler.payload() |Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, driver, delivery_data, result}) do
    max_time = delivery_data["max_delivery_time"]
    case is_driver_valid?(driver, result, max_time) do
      true -> {:ok, driver, delivery_data, result}
      false -> {:error, "Tempo ou distância máxima ultrapassada", :out_of_limits}
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
