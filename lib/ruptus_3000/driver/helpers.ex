defmodule Ruptus3000.Driver.Helpers do
  def meters_to_km(distance) do
    distance / 1000
  end

  def seconds_to_minutes(seconds), do: seconds / 60

  def localization_map(localization) do
    %{latitude: localization["latitude"], longitude: localization["longitude"]}
  end
end
