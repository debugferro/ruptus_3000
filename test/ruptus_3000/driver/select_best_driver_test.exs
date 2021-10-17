defmodule Ruptus3000.Driver.SelectBestDriverTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.{Routing.SelectBestDriver, HandlersHelpers}

  describe "SelectBestDriver.handle/1 tests" do
    test "1) It selects the fastest driver in the list" do
      expected_choice = HandlersHelpers.custom_driver(10, 4)
      result = %{drivers: [
        expected_choice,
        HandlersHelpers.custom_driver(20, 3),
        HandlersHelpers.custom_driver(30, 2),
        HandlersHelpers.custom_driver(40, 1)
      ]}
      {:ok, ^expected_choice, ^result} = SelectBestDriver.handle({:ok, result})
    end

    test "2) It selects the fastest driver in the list" do
      expected_choice = HandlersHelpers.custom_driver(34.4, 1)
      result = %{drivers: [
        HandlersHelpers.custom_driver(34.5, 2),
        expected_choice,
        HandlersHelpers.custom_driver(43.4, 3),
        HandlersHelpers.custom_driver(40.1, 4)
      ]}
      {:ok, ^expected_choice, ^result} = SelectBestDriver.handle({:ok, result})
    end

    test "It selects the driver with the lowest index when there is a tie" do
      expected_choice = HandlersHelpers.custom_driver(30, 1)
      result = %{drivers: [
        HandlersHelpers.custom_driver(30, 2),
        HandlersHelpers.custom_driver(30, 3),
        HandlersHelpers.custom_driver(30, 4),
        expected_choice
      ]}
      {:ok, ^expected_choice, ^result} = SelectBestDriver.handle({:ok, result})
    end

    test "It returns an error when drivers list is empty so there is no best driver" do
      result = %{drivers: []}
      {:error, _msg, :no_drivers} = SelectBestDriver.handle({:ok, result})
    end

    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = SelectBestDriver.handle({:error, "Error", :error})
      assert {:error, "Error"} = SelectBestDriver.handle({:error, "Error"})
    end
  end
end
