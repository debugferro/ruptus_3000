defmodule Ruptus3000.Driver.FilterTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Driver.Filter

  @result %{
    vehicles: %{
      "motorcycle" => %{
        max_range: 30
      }
    },
    to_delivery_point: %{
      distance: 1
    }
  }

  @delivery_data %{
    "max_delivery_time" => 30
  }

  @allowed_driver %{
    "vehicle" => "motorcycle",
    total_distance: 1,
    to_collect_point: %{
      duration: 20,
      distance: 1
    },
    total_time: 28
  }

  @not_allowed_driver_1 %{
    "vehicle" => "motorcycle",
    total_distance: 21,
    to_collect_point: %{
      duration: 20,
      distance: 30
    },
    total_time: 38
  }

  @not_allowed_driver_2 %{
    "vehicle" => "motorcycle",
    to_collect_point: %{
      distance: 30
    },
    total_time: 38
  }

  @allowed_driver_2 %{
    "vehicle" => "motorcycle",
    to_collect_point: %{
      distance: 10
    },
    total_time: 38
  }

  @not_allowed_driver_3 %{
    "vehicle" => "motorcycle",
    total_distance: 31,
    to_collect_point: %{
      duration: 20,
      distance: 30
    },
    total_time: 18
  }

  describe "Filter handler" do
    test "If a drivers total distance is less then his/her vehicle max range,
    and his/her total time is less then the total time, it will return the driver" do
      result = Filter.handle({:ok, @allowed_driver, @delivery_data, @result})

      assert {:ok, @allowed_driver, @delivery_data, @result} = result
    end

    test "If a drivers total time is more then the max time, it will return an error" do
      result = Filter.handle({:ok, @not_allowed_driver_1, @delivery_data, @result})

      assert {:error, _, :no_drivers} = result
    end

    test "If a drivers total distance is more then his/her vehicle max range,
    it will return an error" do
      result = Filter.handle({:ok, @not_allowed_driver_2, @delivery_data, @result})

      assert {:error, _, :no_drivers} = result
    end

    test "If a drivers total distance is less then his/her vehicle max range,
    it will return the driver" do
      result = Filter.handle({:ok, @allowed_driver_2, @delivery_data, @result})

      assert {:ok, @allowed_driver_2, @delivery_data, @result} = result
    end

    test "If a drivers total distance is more then his/her vehicle max range,
    it will return an error (duration condition)" do
      result = Filter.handle({:ok, @not_allowed_driver_3, @delivery_data, @result})

      assert {:error, _, :no_drivers} = result
    end

    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = Filter.handle({:error, "Error", :error})
      assert {:error, "Error"} = Filter.handle({:error, "Error"})
    end
  end
end
