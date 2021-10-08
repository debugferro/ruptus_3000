defmodule Ruptus3000.Driver.Selector do
  @moduledoc """
    Selector is a module responsible for calling all necessary handlers to return the best driver
    to perform a delivery.
  """
  @behaviour Ruptus3000.Driver.SelectorBehaviour
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.{GetDeliveryPath, SelectDriversDistance, CalcStraightPath,
  GetDriversRoutes, FilterDrivers, CheckPriority, SelectBestDriver}

  @spec start(map) :: {:ok, map()} | Error.detailed_tuple() | Error.basic_tuple()
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> SelectDriversDistance.handle()
    |> CalcStraightPath.handle()
    |> FilterDrivers.handle()
    |> GetDriversRoutes.handle()
    |> FilterDrivers.handle()
    |> CheckPriority.handle()
    |> SelectBestDriver.handle()
  end
end
