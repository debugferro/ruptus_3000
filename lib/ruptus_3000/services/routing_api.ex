defmodule Ruptus3000.Services.RoutingApi do
  @callback request_route(%{ latitude: float() | String.t(),
    longitude: float() | String.t()}, %{latitude: float() | String.t(),
    longitude: float() }) :: {:ok, %{required(String.t()) => any()}} | {:error, String.t(), String.t()} | {:error, atom()}

  @callback request_route(String.t(), String.t()) :: {:ok, %{required(String.t()) => any()}} | {:error, String.t(), String.t()} | {:error, atom()}
end
