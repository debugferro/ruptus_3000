defmodule Ruptus3000.Driver.FilterDriversByRange do
  @moduledoc """
    This handler filter drivers by calculating each driver's collect distance (straight line),
    adding the previously routed delivery distance and comparing it with the driver's vehicle
    maximum allowed range.
  """
  @behaviour Ruptus3000.Driver.Handler

  @spec handle({:ok, map(), map()}) ::
          {:error, atom} | {:error, String.t(), atom()} | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    drivers =
      Enum.filter(result.delivery_people, fn driver ->
        driver.straight_distance + result.to_delivery_point.distance <=
          result.vehicles[driver["vehicle"]][:max_range]
      end)

    if drivers == [] do
      {:error, "Não há entregadores disponíveis.", :no_delivery_person}
    else
      {:ok, delivery_data, Map.put(result, :delivery_people, drivers)}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}
end
