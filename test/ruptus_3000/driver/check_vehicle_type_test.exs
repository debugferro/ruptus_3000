defmodule Ruptus3000.Driver.CheckVehicleTypeTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.{Driver.CheckVehicleType, Vehicle, HandlersHelpers}

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

  describe "CheckVehicleType handler" do
    test "If a driver possesses an allowed vehicle it will return a successful response" do
      result = CheckVehicleType.handle({:ok, @allowed_driver, %{}, @result})

      assert {:ok, @allowed_driver, %{}, @result} = result
    end

    test "It returns error when the driver possesses a not listed vehicle"  do
      result = CheckVehicleType.handle({:ok, @not_allowed_driver, %{}, @result})

      assert {:error, _message, _status} = result
    end

    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = CheckVehicleType.handle({:error, "Error", :error})
      assert {:error, "Error"} = CheckVehicleType.handle({:error, "Error"})
    end
  end
end
