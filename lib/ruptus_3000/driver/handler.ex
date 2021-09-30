defmodule Ruptus3000.Driver.Handler do
  alias Ruptus3000.Types.Error
  @callback handle(map() | {:ok, map(), map()}) :: {:ok, map(), map()} | Error.detailed_tuple() | Error.basic_tuple()
  @callback handle(Error.detailed_tuple() | Error.basic_tuple()) :: Error.detailed_tuple() | Error.basic_tuple()
end
