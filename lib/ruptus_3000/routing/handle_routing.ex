defmodule Ruptus3000.Routing.HandleRouting do
  @moduledoc """
    Selector is a module responsible for calling all necessary handlers to return the best driver
    to perform a delivery.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Main
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.HandleDriver
  alias Ruptus3000.Routing.{GetDeliveryPath, CheckPriority, SelectBestDriver, GetVehicles}

  @spec start(map) :: {:ok, map()} | Error.detailed_tuple() | Error.basic_tuple()
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> GetVehicles.handle()
    |> drivers_handlers()
    |> CheckPriority.handle()
    |> SelectBestDriver.handle()
  end

  defp drivers_handlers({:ok, delivery_data, result} = data) do
    case Flow.from_enumerable(delivery_data["drivers"])
      |> Flow.partition(stages: 1)
      |> Flow.reduce(fn -> [] end, &(call_driver_handling(&1, &2, data)))
      |> Enum.to_list() do
        [] -> {:error, "Nenhum entregador disponível", :no_drivers}
        drivers -> {:ok, delivery_data, merge_drivers(drivers, result)}
      end
  end
  defp drivers_handlers(error), do: error

  defp call_driver_handling(driver, acc, {:ok, delivery_data, result}) do
    case HandleDriver.start(driver, delivery_data, result) do
      {:ok, driver, _, _} -> [driver | acc]
      {:error, _, _} -> acc
    end
  end

  defp merge_drivers(drivers, result), do: Map.put(result, :drivers, drivers)
end
