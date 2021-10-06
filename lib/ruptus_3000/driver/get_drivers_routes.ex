defmodule Ruptus3000.Driver.GetDriversRoutes do
  @moduledoc """
    This handler is responsible for calculating, asynchronously, the route of all drivers from their localization
    to the collect point.
  """
  @behaviour Ruptus3000.Driver.Handler
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.Driver.Helpers

  @spec handle({:ok, map(), map()}) :: {:error, String.t(), atom()} | {:ok, map(), map()}
  def handle({:ok, delivery_data, result}) do
    case start_async_requests(result.delivery_people, delivery_data) do
      {:ok, drivers} -> {:ok, delivery_data, Map.put(result, :delivery_people, drivers)}
      {:error, message, status} -> {:error, message, status}
    end
  end

  def handle(error), do: error

  defp start_async_requests(drivers, delivery_data) do
    drivers
    |> Task.async_stream(&request_api(&1, delivery_data["collect_point"]["localization"]), on_timeout: :kill_task)
    |> Enum.map(&handle_info(&1))
    |> check_for_errors()
  end

  defp request_api(driver, collect_point) do
    case GoogleApi.request_route(
        Helpers.localization_map(driver["localization"]),
        Helpers.localization_map(collect_point)
    ) do
      {:ok, response} -> Map.put(driver, :to_collect_point, response |> GoogleApi.filter_response())
      {:error, status} -> Map.put(driver, :to_collect_point, %{error: status})
    end
  end

  defp handle_info({:ok, result}), do: result
  defp handle_info({:exit, :timeout}), do: {:error, "Request timeout", :timeout_get_drivers_routes}
  defp check_for_errors([{:error, message, status} | _]), do: {:error, message, status}
  defp check_for_errors(result), do: {:ok, result}
end
