defmodule Ruptus3000.Driver.HandlerBehaviour do
  alias Ruptus3000.Types.Error
  @callback handle({:ok, map()}) :: {:ok, map()}
  @callback handle(map() | {:ok, map(), map()}) ::
              {:ok, map(), map()} | Error.detailed_tuple() | Error.basic_tuple()
  @callback handle(Error.detailed_tuple() | Error.basic_tuple()) ::
              Error.detailed_tuple() | Error.basic_tuple()
end
