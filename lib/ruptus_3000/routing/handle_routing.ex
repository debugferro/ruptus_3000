defmodule Ruptus3000.Routing.HandleRouting do
  @moduledoc """
    Selector is a module responsible for calling all necessary handlers to return the best driver
    to perform a delivery.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Main
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.HandleDriver

  alias Ruptus3000.Routing.{
    GetDeliveryPath,
    CheckPriority,
    SelectBestDriver,
    GetVehicles,
    BuildResponse,
    Report
  }

  @spec start(map) :: {:ok, map()} | Error.detailed_tuple() | Error.basic_tuple()
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> GetVehicles.handle()
    |> drivers_handlers()
    |> CheckPriority.handle()
    |> SelectBestDriver.handle()
    |> BuildResponse.handle()
    |> Report.handle()
  end

  defp drivers_handlers({:ok, delivery_data, result} = data) do
    case Flow.from_enumerable(delivery_data["drivers"])
         |> Flow.partition(stages: 1)
         |> Flow.reduce(fn -> [{[], []}] end, &call_driver_handling(&1, &2, data))
         |> Enum.to_list() do
      [{[], _}] -> {:error, "Nenhum entregador elegível", :no_drivers}
      drivers -> {:ok, delivery_data, merge_drivers(drivers, result)}
    end
  end

  defp drivers_handlers(error), do: error

  defp call_driver_handling(driver, acc, {:ok, delivery_data, result}) do
    case HandleDriver.start(driver, delivery_data, result) do
      {:ok, driver, _, _} ->
        [{selected, rejected}] = acc
        [{[driver | selected], rejected}]

      {:error, msg, type} ->
        [{selected, rejected}] = acc
        [{selected, [build_rejected_return(driver, msg, type) | rejected]}]
    end
  end

  defp build_rejected_return(driver, msg, type),
    do: Map.put(driver, :error_msg, msg) |> Map.put(:error_type, type)

  defp merge_drivers([{selected, rejected}], result) do
    Map.put(result, :drivers, selected)
    |> Map.put(:rejected_drivers, rejected)
  end
end
