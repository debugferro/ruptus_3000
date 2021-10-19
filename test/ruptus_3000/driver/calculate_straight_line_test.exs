defmodule Ruptus3000.Driver.CalculateStraightLineTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Driver.CalculateStraightLine
  alias Ruptus3000.Routing.Helpers

  @data %{
    "collect_point" => %{
      "localization" => %{
        "latitude" => -105.534,
        "longitude" => 39.123
      }
    }
  }

  @driver %{
    "localization" => %{
      "latitude" => -105.343,
      "longitude" => 39.984
    }
  }

  setup_all do
    expect(Haversine, :distance, fn _, _ -> 1000 end)
    expect(Helpers, :meters_to_km, fn _ -> 1 end)

    :ok
  end

  describe "CalculateStraightLine handler" do
    test "It returns a successful response" do
      result = CalculateStraightLine.handle({:ok, @driver, @data, %{}})
      assert {:ok, _, _, _} = result
    end

    test "It returns to collect point distance inside drivers" do
      result = CalculateStraightLine.handle({:ok, @driver, @data, %{}})

      assert {:ok,
              %{
                to_collect_point: %{
                  distance: _
                }
              }, @data, _} = result
    end

    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = CalculateStraightLine.handle({:error, "Error", :error})
      assert {:error, "Error"} = CalculateStraightLine.handle({:error, "Error"})
    end
  end
end
