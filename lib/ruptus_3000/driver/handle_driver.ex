defmodule Ruptus3000.Driver.HandleDriver do
  @moduledoc """
    This module is responsible for calculating and checking all necessary variables,
    so a driver can perform a delivery successfully. This is a module that assist the Handle Routing module.
  """
  @behaviour Ruptus3000.Driver.Behaviour.Main

  alias Ruptus3000.Driver.{CheckVehicleType, CalculateStraightLine, Filter, GetFullRoute}
  alias Ruptus3000.Types.Error

  @spec start(map(), map(), map()) :: {:ok, map(), map(), map()} | Error.detailed_tuple() | Error.basic_tuple()
  def start(driver, delivery_data, result) do
    {:ok, driver, delivery_data, result}
    |> CheckVehicleType.handle()
    |> CalculateStraightLine.handle()
    |> Filter.handle()
    |> GetFullRoute.handle()
    |> Filter.handle()
  end
end
