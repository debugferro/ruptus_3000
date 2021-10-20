defmodule Ruptus3000.Routing.SelectBestDriver do
  @moduledoc """
    This handler returns the fastest driver to be responsible for a delivery.
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, delivery_data, result}) do
    Enum.reduce(result.drivers, %{}, fn driver, previous_driver ->
      cond do
        %{} == previous_driver -> driver
        driver["index"] < previous_driver["index"] and driver.total_time > previous_driver.total_time -> previous_driver
        driver["index"] <= previous_driver["index"] and driver.total_time <= previous_driver.total_time -> driver
        driver["index"] > previous_driver["index"] and driver.total_time < previous_driver.total_time -> driver
        driver["index"] >= previous_driver["index"] and driver.total_time >= previous_driver.total_time -> previous_driver
      end
    end)
    |> build_response(result, delivery_data)
  end

  def handle(error), do: error

  defp build_response(selected_driver, _result, _dd) when map_size(selected_driver) == 0, do: {:error, "No drivers available", :no_drivers}
  defp build_response(selected_driver, result, delivery_data), do: {:ok, delivery_data, Map.put(result, :selected_driver, selected_driver)}
end
