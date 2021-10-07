defmodule Ruptus3000.Driver.SelectDriversDistanceTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.{Driver.SelectDriversDistance, Vehicle, HandlersHelpers}

  @delivery_data %{
    "delivery_people" => [%{
      "id" => 1,
      "vehicle" => "bike"
    },
    %{
      "id" => 2,
      "vehicle" => "motorcycle"
    }]
  }

  @result %{
    to_delivery_point: %{
      distance: 4.0
    }
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Ruptus3000.Repo)
  end

  describe "SelectDriversDistance handler" do
    test "It returns vehicles and filtered delivery people in results" do
      Vehicle
      |> expect(:get_vehicles_by_max_range, fn _ -> HandlersHelpers.vehicle_query() end)
      result = SelectDriversDistance.handle({:ok, @delivery_data, @result})

      assert {:ok, @delivery_data, %{
        vehicles: %{
          "motorcycle" => %{
            max_range: _,
            priority_range_start: _,
            priority_range_end: _
          }
        },
        delivery_people: [%{
          "id" => 2,
          "vehicle" => "motorcycle"
        }]
      }} = result
    end

    test "It returns error when there is no drivers available"  do
      result = SelectDriversDistance.handle({:ok, %{"delivery_people" => []}, @result})

      assert {:error, _message, _status} = result
    end
  end
end
