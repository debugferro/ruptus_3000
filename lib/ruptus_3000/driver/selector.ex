defmodule Ruptus3000.Driver.Selector do
  @moduledoc """
    TO DO
  """
  @behaviour Ruptus3000.Driver.MainBehaviour
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.{GetDeliveryPath, SelectDriversDistance, CalcStraightPath,
  GetDriversRoutes, FilterDriversByRange, CheckPriority, SelectBestDriver}

  @spec start(map) :: {:ok, map()} | Error.detailed_tuple() | Error.basic_tuple()
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> SelectDriversDistance.handle()
    |> CalcStraightPath.handle()
    |> FilterDriversByRange.handle()
    |> GetDriversRoutes.handle()
    |> FilterDriversByRange.handle()
    |> CheckPriority.handle()
    |> SelectBestDriver.handle()
  end
end
