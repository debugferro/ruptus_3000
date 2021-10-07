defmodule Ruptus3000.Driver.CalcStraightPath do
  @moduledoc """
    This handler is responsible for calculating a straigh path from each driver's locations to
    the collect point localization.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  require Haversine

  alias Ruptus3000.Driver.Helpers
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    drivers = calculate(result.drivers, delivery_data)
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
        |> Helpers.meters_to_km()

      Map.put(driver, :to_collect_point, %{distance: distance})
    end)
  end

  defp build_return(result, drivers), do: Map.put(result, :drivers, drivers)
  defp build_localization(localization), do: {localization["longitude"], localization["latitude"]}
end
