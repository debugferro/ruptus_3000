defmodule Ruptus3000.Routing.CheckPriorityTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Routing.CheckPriority
  alias Ruptus3000.HandlersHelpers

  @vehicles HandlersHelpers.multiple_vehicles_query()

  @result %{
    drivers: [
      HandlersHelpers.basic_biker(),
      HandlersHelpers.basic_motorcycle(),
      HandlersHelpers.basic_biker(),
      HandlersHelpers.basic_motorcycle()
    ],
    vehicles: HandlersHelpers.vehicle_list()
  }

  describe "CheckPriority handler on prioritizing drivers" do
    test "It should only return drivers with motorcycle" do
      result = CheckPriority.handle({:ok, %{}, Map.put(@result, :to_delivery_point, %{distance: 3})})
      assert {:ok, %{drivers: [%{
        "vehicle" => "motorcycle"
        },
        %{
          "vehicle" => "motorcycle"
        }]
      }} = result
    end

    test "It should only return drivers with bikes" do
      result = CheckPriority.handle({:ok, %{}, Map.put(@result, :to_delivery_point, %{distance: 1})})
      assert {:ok, %{drivers: [%{
        "vehicle" => "bike"
        },
        %{
          "vehicle" => "bike"
        }]
      }} = result
    end
  end

  describe "CheckPriority handler on errors" do
    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = CheckPriority.handle({:error, "Error", :error})
      assert {:error, "Error"} = CheckPriority.handle({:error, "Error"})
    end
  end
end
