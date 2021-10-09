defmodule Ruptus3000.Driver.Selector do
  @moduledoc """
    Selector is a module responsible for calling all necessary handlers to return the best driver
    to perform a delivery.
  """
  @behaviour Ruptus3000.Driver.SelectorBehaviour
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.{GetDeliveryPath, SelectDriversDistance, CalcStraightPath,
  GetDriversRoutes, FilterDrivers, CheckPriority, SelectBestDriver, GetVehicles}

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
    {:ok, delivery_data,
      Flow.from_enumerable(delivery_data["drivers"])
      |> Flow.partition(stages: 1)
      |> Flow.reduce(fn -> [] end, &(handle_drivers(&1, &2, data)))
      |> Enum.to_list()
      |> merge_drivers(result)
    }
  end

  defp handle_drivers(driver, acc, {:ok, delivery_data, result}) do
    case call_driver_handlers({:ok, driver, delivery_data, result}) do
      {:ok, driver, _, _} -> [driver | acc]
      {:error, _, _} -> acc
    end
  end

  defp call_driver_handlers(to_handle_data) do
    to_handle_data
    |> SelectDriversDistance.handle()
    |> CalcStraightPath.handle()
    |> FilterDrivers.handle()
    |> GetDriversRoutes.handle()
    |> FilterDrivers.handle()
  end

  defp merge_drivers(drivers, result), do: Map.put(result, :drivers, drivers)
end
