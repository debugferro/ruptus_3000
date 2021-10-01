defmodule Ruptus3000.Driver.Selector do
  @moduledoc """
    TO DO
  """

  @behaviour Ruptus3000.Driver.MainBehaviour

  alias Ruptus3000.Driver.GetDeliveryPath
  alias Ruptus3000.Driver.SelectDriversDistance

  @spec start(map) :: {:ok, map()}
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> SelectDriversDistance.handle()
  end
end
