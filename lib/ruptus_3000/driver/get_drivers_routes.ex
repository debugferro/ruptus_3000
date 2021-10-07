defmodule Ruptus3000.Driver.GetDriversRoutes do
  @moduledoc """
    This handler is responsible for calculating, asynchronously, the route of all drivers from their localization
    to the collect point.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.Driver.Helpers
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          Error.basic_tuple() | Error.detailed_tuple() | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    case start_async_requests(result, delivery_data) do
      {:ok, drivers} -> {:ok, delivery_data, Map.put(result, :drivers, drivers)}
      {:error, message, status} -> {:error, message, status}
    end
  end

  def handle(error), do: error

  defp start_async_requests(result, delivery_data) do
    result.drivers
    |> Task.async_stream(&request_api(&1, delivery_data["collect_point"]["localization"], result),
      on_timeout: :kill_task,
      ordered: false
    )
    |> Enum.map(&handle_info(&1))
    |> check_for_errors()
  end

  defp request_api(driver, collect_point, result) do
    case GoogleApi.request_route(
           Helpers.localization_map(driver["localization"]),
           Helpers.localization_map(collect_point)
         ) do
      {:ok, response} ->
        build_driver_info(driver, response |> GoogleApi.filter_response(), result)

      {:error, status} ->
        Map.put(driver, :to_collect_point, %{error: status})
    end
  end

  defp build_driver_info(driver, response, result) do
    Map.put(driver, :to_collect_point, response)
    |> Map.put(:total_time, response.duration + result.to_delivery_point.duration)
    |> Map.put(:total_distance, response.distance + result.to_delivery_point.distance)
  end

  defp handle_info({:ok, result}), do: result

  defp handle_info({:exit, :timeout}),
    do: {:error, "Request timeout", :timeout_get_drivers_routes}

  defp check_for_errors([{:error, message, status} | _]), do: {:error, message, status}
  defp check_for_errors(result), do: {:ok, result}
end
