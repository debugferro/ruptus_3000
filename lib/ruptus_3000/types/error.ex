defmodule Ruptus3000.Types.Error do
  @type detailed_tuple() :: {:error, String.t(), String.t() | atom() | integer()}
  @type basic_tuple() :: {:error, String.t() | atom() | integer()}
end
