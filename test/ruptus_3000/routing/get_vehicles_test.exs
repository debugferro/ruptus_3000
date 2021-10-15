defmodule Ruptus3000.Routing.GetVehiclesTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Vehicle
  alias Ruptus3000.Routing.GetVehicles
  alias Ruptus3000.HandlersHelpers

  @vehicles HandlersHelpers.multiple_vehicles_query()

  setup_all do
    Vehicle |> expect(:get_vehicles_by_max_range, fn _ -> @vehicles end)
    [result: GetVehicles.handle({:ok, %{}, %{to_delivery_point: %{ distance: 2}}})]
  end

  describe "GetVehicles handler" do
    test "It inserts vehicles key and values inside result", %{result: result} do
      {:ok, %{}, %{
        vehicles: %{
          "bike" => %{
            max_range: 2,
            priority_range_start: 0,
            priority_range_end: 2
          },
          "motorcycle" => %{
            max_range: 30.0,
            priority_range_start: 2.1,
            priority_range_end: 30.0
          }
        }
      }} = result
    end

    test "It returns a label list key inside result/vehicles with all vehicles names", %{result: result} do
      assert {:ok, %{}, %{
        vehicles: %{
          label_list: ["bike", "motorcycle"]
        }
      }} = result
    end
  end
end
