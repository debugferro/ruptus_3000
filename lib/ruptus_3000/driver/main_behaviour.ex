defmodule Ruptus3000.Driver.MainBehaviour do
  alias Ruptus3000.Types.Error
  @callback start(map()) :: {:ok, map()} | Error.detailed_tuple() | Error.basic_tuple()
end
