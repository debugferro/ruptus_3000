defmodule Ruptus3000.Driver.CalculateStraightLine do
  @moduledoc """
    This handler is responsible for calculating a straigh line path from driver's locations to
    the collect point localization.
  """
  @behaviour Ruptus3000.Driver.Behaviour.Handler
  require Haversine

  alias Ruptus3000.Routing.Helpers
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.Behaviour.Handler

  @spec handle(Handler.payload() | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | Handler.payload()
  def handle({:ok, driver, delivery_data, result}) do
    case calculate(driver["localization"], delivery_data["collect_point"]["localization"]) do
      {:ok, distance} -> {:ok, build_driver(driver, distance), delivery_data, result}
      {:error} -> {:error, "Driver has no valid localization", :invalid_localization}
    end
  end

  def handle({:error, message, status}), do: {:error, message, status}
  def handle({:error, status}), do: {:error, status}
  defp calculate(%{"longitude" => _, "latitude" => _} = driver_localization, collect_point_localization) do
    {:ok, Haversine.distance(
      build_localization(driver_localization),
      build_localization(collect_point_localization)
      )
      |> Helpers.meters_to_km()}
  end

  defp calculate(nil, _), do: {:error}
  defp calculate(_, _), do: {:error}

  defp build_driver(driver, distance), do: Map.put(driver, :to_collect_point, %{distance: distance})
  defp build_localization(localization), do: {localization["longitude"], localization["latitude"]}
end
