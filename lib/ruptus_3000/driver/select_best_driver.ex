defmodule Ruptus3000.Driver.SelectBestDriver do
  @moduledoc """
    This handler returns the fastest driver to be responsible for a delivery.
  """
  @behaviour Ruptus3000.Driver.HandlerBehaviour
  alias Ruptus3000.Types.Error

  @spec handle({:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, result}) do
    Enum.reduce(result.drivers, %{}, fn driver, acc ->
      cond do
        %{} == acc -> driver
        driver["index"] < acc["index"] and driver.total_time > acc.total_time -> acc
        driver["index"] <= acc["index"] and driver.total_time <= acc.total_time -> driver
        driver["index"] > acc["index"] and driver.total_time < acc.total_time -> driver
        driver["index"] >= acc["index"] and driver.total_time >= acc.total_time -> acc
      end
    end)
    |> build_response()
  end

  def handle(error), do: error

  defp build_response([]), do: {:error, "No drivers available", :no_drivers}
  defp build_response(selected_driver), do: {:ok, selected_driver}
end
