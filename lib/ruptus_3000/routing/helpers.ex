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

  def checkpoint_validity(%{"collect_point" => %{"localization" => localization}}, :collect), do: {:ok, localization}
  def checkpoint_validity(%{"delivery_point" => %{"localization" => localization}}, :delivery), do: {:ok, localization}
  def checkpoint_validity(_data, :collect), do: {:error, "collect_point"}
  def checkpoint_validity(_data, :delivery), do: {:error, "delivery_point"}
end
