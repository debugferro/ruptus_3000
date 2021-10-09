defmodule Ruptus3000.Driver.SelectDriversDistanceTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.{Driver.SelectDriversDistance, Vehicle, HandlersHelpers}

  @result %{
    vehicles: %{
      label_list: ["motorcycle"]
    }
  }

  @allowed_driver %{
    "id" => 2,
    "vehicle" => "motorcycle"
  }

  @not_allowed_driver %{
    "id" => 2,
    "vehicle" => "bike"
  }

  describe "SelectDriversDistance handler" do
    test "If a driver possesses an allowed vehicle it will return a successful response" do
      result = SelectDriversDistance.handle({:ok, @allowed_driver, %{}, @result})

      assert {:ok, @allowed_driver, %{}, @result} = result
    end

    test "It returns error when the driver possesses a not listed vehicle"  do
      result = SelectDriversDistance.handle({:ok, @not_allowed_driver, %{}, @result})

      assert {:error, _message, _status} = result
    end
  end
end
