defmodule Ruptus3000.Driver.Behaviour.Main do
  alias Ruptus3000.Types.Error
  @callback start(map(), map(), map()) :: {:ok, map(), map(), map()} | Error.detailed_tuple() | Error.basic_tuple()
end
