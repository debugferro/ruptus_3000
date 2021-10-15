defmodule Ruptus3000.Routing.Helpers do

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

  def get_localization(%{"collect_point" => %{"localization" => localization}}, :collect), do: {:ok, localization}
  def get_localization(%{"delivery_point" => %{"localization" => localization}}, :delivery), do: {:ok, localization}
  def get_localization(_data, :collect), do: {:not_valid, "collect_point"}
  def get_localization(_data, :delivery), do: {:not_valid, "delivery_point"}
end
