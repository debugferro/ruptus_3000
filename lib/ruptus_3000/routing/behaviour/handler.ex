defmodule Ruptus3000.Routing.Behaviour.Handler do
  alias Ruptus3000.Types.Error
  @type payload() :: {:ok, map(), map()}
  @callback handle(map()) :: {:ok, map()} | payload()
  @callback handle({:ok, map()}) :: {:ok, map()}
  @callback handle(payload()) :: {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  @callback handle(Error.basic_tuple()) :: Error.basic_tuple()
  @callback handle(Error.detailed_tuple()) :: Error.detailed_tuple()
end
