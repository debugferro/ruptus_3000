defmodule Ruptus3000.Driver.CalcStraightPath do
  @moduledoc """
    This handler is responsible for calculating a straigh path from each driver's locations to
    the collect point localization.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  require Haversine

  alias Ruptus3000.Driver.Helpers
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map(), map(), map()}
  def handle({:ok, driver, delivery_data, result}) do
    distance = calculate(driver["localization"], delivery_data["collect_point"]["localization"])
    {:ok, build_driver(driver, distance), delivery_data, result}
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}

  defp calculate(driver_localization, collect_point_localization) do
    Haversine.distance(
      build_localization(driver_localization),
      build_localization(collect_point_localization)
    )
    |> Helpers.meters_to_km()
  end

  defp build_driver(driver, distance), do: Map.put(driver, :to_collect_point, %{distance: distance})
  defp build_localization(localization), do: {localization["longitude"], localization["latitude"]}
end
