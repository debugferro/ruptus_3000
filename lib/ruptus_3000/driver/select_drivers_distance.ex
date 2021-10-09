defmodule Ruptus3000.Driver.SelectDriversDistance do
  @moduledoc """
      This handler is reponsible for returning all drivers that have a vehicle
      with a max range greater than or equal to the delivery distance.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map(), map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, driver, delivery_data, result}) do
    case is_driver_vehicle_valid?(result.vehicles.label_list, driver["vehicle"]) do
      true -> {:ok, driver, delivery_data, result}
      false -> {:error, "Tipo de veículo não permite essa viagem", :vehicle_not_allowed}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp is_driver_vehicle_valid?(vehicles, driver_vehicle), do: Enum.member?(vehicles, driver_vehicle)
end
