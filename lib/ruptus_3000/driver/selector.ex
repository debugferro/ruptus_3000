defmodule Ruptus3000.Driver.Selector do
  @behaviour Ruptus3000.Driver.MainBehaviour

  alias Ruptus3000.Driver.GetDeliveryPath

  @spec start(map) :: {:ok, map()}
  def start(delivery_data) do
    delivery_data
    |> GetDeliveryPath.handle()
    |> IO.inspect
  end
end
