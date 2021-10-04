defmodule Ruptus3000.Driver.CalcStraightPath do
  @behaviour Ruptus3000.Driver.Handler
  alias Haversine
  alias Ruptus3000.Vehicle.Converter

  @spec handle({:ok, map(), map()}) ::
          {:error, atom} | {:error, String.t(), atom()} | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    drivers = calculate(result.delivery_people, delivery_data)
    {:ok, delivery_data, build_return(result, drivers)}
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp calculate(drivers, delivery_data) do
    Enum.map(drivers, fn driver ->
      distance =
        Haversine.distance(
          build_localization(driver["localization"]),
          build_localization(delivery_data["collect_point"]["localization"])
        )
        |> Converter.meters_to_km()

      Map.put(driver, :straight_distance, distance)
    end)
  end

  defp build_return(result, drivers), do: Map.put(result, :delivery_people, drivers)
  defp build_localization(localization), do: {localization["longitude"], localization["latitude"]}
end
