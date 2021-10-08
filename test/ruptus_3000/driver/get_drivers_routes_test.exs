defmodule Ruptus3000.Driver.GetDriversRoutesTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Driver.GetDriversRoutes
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

  describe "GetDeliveryPath handler" do
    test "It returns a successful response" do
      expect(GoogleApi, :request_route, fn _, _ -> {:ok, %{}} end)
      expect(GoogleApi, :filter_response, fn _ -> GoogleApiHelper.filter_response() end)

      result = GetDriversRoutes.handle({:ok, @data, HandlersHelpers.fake_result()})
      assert {:ok, @data, _} = result
    end

    test "It returns to collect point distance, duration and polyline inside drivers" do
      expect(GoogleApi, :request_route, fn _, _ -> {:ok, %{}} end)
      expect(GoogleApi, :filter_response, fn _ -> GoogleApiHelper.filter_response() end)

      result = GetDriversRoutes.handle({:ok, @data, HandlersHelpers.fake_result()})
      assert {:ok, @data, %{
        drivers: [%{
          to_collect_point: %{
            distance: _,
            duration: _,
            polyline: _
          }
        }],
      }} = result
    end

    test "It returns total time and total distance inside drivers" do
      expect(GoogleApi, :request_route, fn _, _ -> {:ok, %{}} end)
      expect(GoogleApi, :filter_response, fn _ -> GoogleApiHelper.filter_response() end)

      result = GetDriversRoutes.handle({:ok, @data, HandlersHelpers.fake_result()})
      assert {:ok, @data, %{
        drivers: [%{
          total_time: 2881,
          total_distance: 67.811,
        }]
      }} = result
    end
  end
end
