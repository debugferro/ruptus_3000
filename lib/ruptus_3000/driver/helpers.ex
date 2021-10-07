defmodule Ruptus3000.Driver.Helpers do
  @spec meters_to_km(number) :: float
  def meters_to_km(distance) do
    distance / 1000
  end

  @spec seconds_to_minutes(number) :: float
  def seconds_to_minutes(seconds), do: seconds / 60

  @spec localization_map(%{:latitude => any(), :longitude => any()}) :: %{latitude: any, longitude: any}
  def localization_map(localization) do
    %{latitude: localization["latitude"], longitude: localization["longitude"]}
  end
end
