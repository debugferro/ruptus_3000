defmodule Ruptus3000.Driver.GetFullRoute do
  @moduledoc """
    This handler is responsible for calculating, the route of a driver from its current localization
    to the collect point.
  """
  @behaviour Ruptus3000.Driver.Behaviour.Handler
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.Driver.Helpers
  alias Ruptus3000.Types.Error
  alias Ruptus3000.Driver.Behaviour.Handler

  @spec handle(Handler.payload() | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | Handler.payload()
  def handle({:ok, driver, delivery_data, result}) do
    case request_api(driver, delivery_data["collect_point"]["localization"], result) do
      {:ok, driver} -> {:ok, driver, delivery_data, result}
      error -> error
    end
  end

  def handle(error), do: error

  defp request_api(driver, collect_point, result) do
    case GoogleApi.request_route(
           Helpers.localization_map(driver["localization"]),
           Helpers.localization_map(collect_point)
         ) do
      {:ok, response} ->
        {:ok, build_driver_info(driver, response |> GoogleApi.filter_response(), result)}

      error -> error
    end
  end

  defp build_driver_info(driver, response, result) do
    Map.put(driver, :to_collect_point, response)
    |> Map.put(:total_time, response.duration + result.to_delivery_point.duration)
    |> Map.put(:total_distance, response.distance + result.to_delivery_point.distance)
  end
end
