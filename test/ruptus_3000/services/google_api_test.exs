defmodule Ruptus3000.GoogleApiTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Ruptus3000.Services.GoogleApi
  alias Ruptus3000.GoogleApiHelper
  alias Ruptus3000.Routing.Helpers

  @start_coordinates %{latitude: 33.81235029151803, longitude: -117.91837280484145}
  @end_coordinates %{latitude: 34.13824110217347, longitude: -118.3533032001647}

  describe "GoogleApi.request_route/2" do
    test "It deals with a successful request for route" do
      expect(HTTPoison, :get!, fn _, _, _ ->
        %{body: GoogleApiHelper.non_decoded_body(:successful), status_code: 200}
      end)

      assert {:ok, %{"status" => "OK"}} =
               GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end

    test "It deals with a unsuccessful request for route" do
      expect(HTTPoison, :get!, fn _, _, _ ->
        %{body: GoogleApiHelper.non_decoded_body(:unsuccessful), status_code: 200}
      end)

      assert {:error, "Could not route", "NO_ROUTE"} =
               GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end

    test "It deals with unsuccessful status code" do
      expect(HTTPoison, :get!, fn _, _, _ -> %{status_code: 404} end)

      assert {:error, :not_found} = GoogleApi.request_route(@start_coordinates, @end_coordinates)
    end
  end

  describe "GoogleApi.filter_response/1" do
    test "It returns a map with distance, duration and polyline" do
      expect(Helpers, :meters_to_km, fn 57811 -> 57.811 end)
      expect(Helpers, :seconds_to_minutes, fn 2871 -> 47.85 end)

      {:ok, response} = GoogleApiHelper.common_response()
      assert %{distance: 57.811, duration: 47.85, polyline: "polyline"} =
               GoogleApi.filter_response(response)
    end
  end
end
