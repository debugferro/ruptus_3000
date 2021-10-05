defmodule Ruptus3000.Driver.Selector do
  @moduledoc """
    TO DO
  """

  @behaviour Ruptus3000.Driver.MainBehaviour

  alias Ruptus3000.Driver.GetDeliveryPath
  alias Ruptus3000.Driver.SelectDriversDistance
  alias Ruptus3000.Driver.CalcStraightPath
  alias Ruptus3000.Driver.FilterDriversByRange

  @spec start(map) :: {:ok, map()}
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> SelectDriversDistance.handle()
    |> CalcStraightPath.handle()
    |> FilterDriversByRange.handle()
  end
end
