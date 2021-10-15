defmodule Ruptus3000.Routing.GetDeliveryPathTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Routing.GetDeliveryPath
  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.Routing.Helpers
  alias Ruptus3000.GoogleApiHelper

  @localization %{
    "latitude" => 34.13824110217347,
    "longitude" => -118.3533032001647
  }

  @data %{
    "collect_point" => %{
      "localization" => %{
        "latitude" => 33.81235029151803,
        "longitude" => -117.91837280484145
      }
    },
    "delivery_point" => %{
      "localization" => @localization
    }
  }

  describe "GetDeliveryPath handler on successful responses" do
    setup do
      GoogleApi
      |> expect(:request_route, fn _, _ -> GoogleApiHelper.common_response() end)
      |> expect(:filter_response, fn _ -> GoogleApiHelper.filter_response() end)

      Helpers
      |> expect(:get_localization, fn _, _ -> {:ok, @localization} end)

      [result: GetDeliveryPath.handle(@data)]
    end

    test "It returns a successful response", %{result: result} do
      assert {:ok, @data, _} = result
    end

    test "It returns a map with the parsed response", %{result: result} do
      {_, _, result_info} = result
      assert %{to_delivery_point: %{ distance: _, duration: _, polyline: _}} = result_info
      assert %{to_delivery_point: GoogleApiHelper.filter_response()} == result_info
    end
  end

  describe "GetDeliveryPath handler on unsuccessful api responses" do
    test "It returns a complete unsuccessful response" do
      GoogleApi
      |> expect(:request_route, fn _, _ -> {:error, "error", "status"} end)

      assert {:error, "error", "status"} = GetDeliveryPath.handle(@data)
    end

    test "It returns a basic unsuccessful response" do
      GoogleApi
      |> expect(:request_route, fn _, _ -> {:error, "status"} end)

      assert {:error, "status"} = GetDeliveryPath.handle(@data)
    end
  end

  describe "GetDeliveryPath handler on invalid payload" do
    test "It returns an error when localization is invalid" do
      Helpers
      |> expect(:get_localization, fn _, _ -> {:not_valid, "collect_point"} end)
      assert {:error, _msg, :invalid_payload} = GetDeliveryPath.handle(@data)
    end
  end
end
