defmodule Ruptus3000.Routing.RecordData do
  @moduledoc """
    This handler start a task to save result data
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Delivery

  @spec handle({:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, result} = response) do
    Task.start(fn ->
      Delivery.create_shipment_from_result(result)
    end)

    response
  end

  def handle(error), do: error
end
