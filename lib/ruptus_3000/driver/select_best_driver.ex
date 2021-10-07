defmodule Ruptus3000.Driver.SelectBestDriver do
  @behaviour Ruptus3000.Driver.Handler

  def handle({:ok, delivery_data, result}) do
    Enum.reduce(result.delivery_people, %{}, fn driver, acc ->
      cond do
        %{} == acc -> driver
        driver["index"] < acc["index"] and driver.total_time > acc.total_time -> acc
        driver["index"] < acc["index"] and driver.total_time <= acc.total_time -> driver
        driver["index"] > acc["index"] and driver.total_time < acc.total_time -> driver
        driver["index"] > acc["index"] and driver.total_time >= acc.total_time -> acc
      end
    end)
    |> build_response()
  end

  def handle(error), do: error

  defp build_response(selected_driver), do: {:ok, selected_driver}
end
