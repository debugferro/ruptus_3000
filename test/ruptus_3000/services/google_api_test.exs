defmodule Ruptus3000.GoogleApiTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.GoogleApiHelper
  alias Ruptus3000.Vehicle.Converter

  @start_coordinates %{latitude: 33.81235029151803, longitude: -117.91837280484145}
  @end_coordinates %{latitude: 34.13824110217347, longitude: -118.3533032001647}

  describe "GoogleApi.request_route/2 expects..." do
    test "It to deal with a successful request for route" do
      expect(HTTPoison, :get!, fn _, _, _ ->
        %{body: GoogleApiHelper.non_decoded_body(:successful), status_code: 200}
      end)

      assert {:ok, %{"status" => "OK"}} =
               GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end

    test "It to deal with a unsuccessful request for route" do
      expect(HTTPoison, :get!, fn _, _, _ ->
        %{body: GoogleApiHelper.non_decoded_body(:unsuccessful), status_code: 200}
      end)

      assert {:error, "Could not route", "NO_ROUTE"} =
               GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end

    test "It to deal with unsuccessful status code" do
      expect(HTTPoison, :get!, fn _, _, _ -> %{status_code: 404} end)

      assert {:error, :not_found} = GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end
  end

  describe "GoogleApi.filter_response/1 expects..." do
    test "It to return a map with distance, duration and polyline" do
      expect(Converter, :meters_to_km, fn 57811 -> 57.811 end)

      {:ok, response} = GoogleApiHelper.common_response()
      assert %{distance: 57.811, duration: 2871, polyline: "polyline"} =
               GoogleApi.filter_response(response)
    end
  end
end
