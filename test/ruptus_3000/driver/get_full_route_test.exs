defmodule Ruptus3000.Driver.GetFullRouteTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Driver.GetFullRoute
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.GoogleApiHelper
  alias Ruptus3000.HandlersHelpers

  @data %{
    "collect_point" => %{
      "localization" => %{
        "latitude" => 33.81235029151803,
        "longitude" => -117.91837280484145
      }
    },
    "delivery_point" => %{
      "localization" => %{
        "latitude" => 34.13824110217347,
        "longitude" => -118.3533032001647
      }
    }
  }

  @driver %{
    "localization" => %{
      "latitude" => 10,
      "longitude" => 10
    }
  }

  setup_all do
    expect(GoogleApi, :request_route, fn _, _ -> {:ok, %{}} end)
    expect(GoogleApi, :filter_response, fn _ -> GoogleApiHelper.filter_response() end)

    [result: GetFullRoute.handle({:ok, @driver, @data, HandlersHelpers.fake_result()})]
  end

  describe "GetDeliveryPath handler" do
    test "It returns a successful response", %{result: result} do
      assert {:ok, @driver, @data, _} = result
    end

    test "It returns to collect point distance, duration and polyline inside drivers", %{result: result} do
      assert {:ok, %{
          to_collect_point: %{
            distance: _,
            duration: _,
            polyline: _
          }
        }, @data, _} = result
    end

    test "It returns total time and total distance inside drivers", %{result: result} do
      assert {:ok, %{
          total_time: 2881,
          total_distance: 67.811,
        }, @data, _} = result
    end

    test "It passes an error forward when it receives an error argument" do
      assert {:error, "Error", :error} = GetFullRoute.handle({:error, "Error", :error})
      assert {:error, "Error"} = GetFullRoute.handle({:error, "Error"})
    end
  end
end
