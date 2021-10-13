defmodule Ruptus3000.Driver.Behaviour.Handler do
  alias Ruptus3000.Types.Error
  @type payload() :: {:ok, map(), map(), map()}
  @callback handle(payload()) :: payload() | Error.detailed_tuple() | Error.basic_tuple()
  @callback handle(Error.detailed_tuple()) :: Error.detailed_tuple()
  @callback handle(Error.basic_tuple()) :: Error.basic_tuple()
end
