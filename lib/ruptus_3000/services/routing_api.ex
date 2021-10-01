defmodule Ruptus3000.Services.RoutingApi do
  alias Ruptus3000.Types.Coordinates

  @callback request_route(Coordinates.t(), Coordinates.t()) ::
              {:ok, %{required(String.t()) => any()}}
              | {:error, String.t(), String.t()}
              | {:error, atom()}

  @callback request_route(String.t(), String.t()) ::
              {:ok, %{required(String.t()) => any()}}
              | {:error, String.t(), String.t()}
              | {:error, atom()}
  @callback filter_response(map()) :: %{
              distance: String.t() | integer() | float(),
              duration: String.t() | integer(),
              polyline: String.t()
            }
end
