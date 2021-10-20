defmodule Ruptus3000.Routing.SelectBestDriver do
  @moduledoc """
    This handler returns the fastest driver to be responsible for a delivery.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, delivery_data, result}) do
    Enum.reduce(result.drivers, {%{}, []}, fn driver, {previous_driver, driver_list} ->
      cond do
        %{} == previous_driver -> {driver, []}
        driver["index"] < previous_driver["index"] and driver.total_time > previous_driver.total_time -> {previous_driver, [driver | driver_list]}
        driver["index"] <= previous_driver["index"] and driver.total_time <= previous_driver.total_time -> {driver, [previous_driver | driver_list]}
        driver["index"] > previous_driver["index"] and driver.total_time < previous_driver.total_time -> {driver, [previous_driver | driver_list]}
        driver["index"] >= previous_driver["index"] and driver.total_time >= previous_driver.total_time -> {previous_driver, [driver | driver_list]}
      end
    end)
    |> build_response(result, delivery_data)
  end

  def handle(error), do: error

  defp build_response({selected_driver, _driver_list}, _result, _dd) when map_size(selected_driver) == 0, do: {:error, "No drivers available", :no_drivers}
  defp build_response({selected_driver, driver_list}, result, delivery_data) do
    {:ok, delivery_data, Map.put(result, :selected_driver, selected_driver)
    |> Map.put(:rejected_drivers, [Map.get(result, :rejected_drivers) | [driver_list]] |> List.flatten())}
  end
end
