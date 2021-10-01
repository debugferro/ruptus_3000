defmodule Ruptus3000.Driver.SelectDriversDistance do
  @moduledoc """
      This handler is reponsible for returning all drivers that have a vehicle
      with a max range greater than or equal to the delivery distance.
  """

  @behaviour Ruptus3000.Driver.Handler
  alias Ruptus3000.Vehicle

  def handle({:ok, delivery_data, result}) do
    drivers = select_delivery_people(delivery_data["delivery_people"], result.to_delivery_point.distance)
    case drivers do
        [] -> {:error, "Não há entregadores disponíveis.", :no_delivery_person}
        _ -> {:ok, delivery_data, build_return(drivers, result)}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp select_delivery_people(delivery_people, distance) do
    vehicles =
      Vehicle.get_vehicles_by_max_range(distance)
      |> Vehicle.build_label_list()

    Enum.filter(delivery_people, fn person ->
      Enum.member?(vehicles, person["vehicle"])
    end)
  end

  defp build_return(drivers, result) do
    Map.put(result, :delivery_people, drivers)
  end
end
