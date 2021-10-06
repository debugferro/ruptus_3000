defmodule Ruptus3000.Driver.GetDeliveryPathTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Driver.GetDeliveryPath
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.GoogleApiHelper

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

  setup_all do
    GoogleApi
    |> expect(:request_route, fn _start_point, _end_point -> GoogleApiHelper.common_response() end)
    |> expect(:filter_response, fn _response -> GoogleApiHelper.filter_response() end)

    [result: GetDeliveryPath.handle(@data)]
  end

  describe "GetDeliveryPath handler" do
    test "It returns a successful response", %{result: result} do
      assert {:ok, @data, _} = result
    end

    test "It returns a map with the parsed response", %{result: result} do
      {_, _, result_info} = result
      assert %{to_delivery_point: %{ distance: _, duration: _, polyline: _}} = result_info
      assert %{to_delivery_point: GoogleApiHelper.filter_response()} == result_info
    end
  end
end
