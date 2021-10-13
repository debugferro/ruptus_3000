defmodule Ruptus3000.Driver.CheckVehicleType do
  @moduledoc """
      This handler is reponsible for checking if driver's vehicle is allowed
      to perform this delivery. It checks if it is a member of the allowed vehicles list.
  """
  @behaviour Ruptus3000.Driver.Behaviour.Handler
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.Behaviour.Handler

  @spec handle(Handler.payload() | Error.basic_tuple() | Error.detailed_tuple()) ::
    Handler.payload() | Error.basic_tuple() | Error.detailed_tuple()
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
