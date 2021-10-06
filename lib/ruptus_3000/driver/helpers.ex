defmodule Ruptus3000.Driver.Helpers do
  def meters_to_km(distance) do
    distance / 1000
  end

  def localization_map(localization) do
    %{latitude: localization["latitude"], longitude: localization["longitude"]}
  end
end
