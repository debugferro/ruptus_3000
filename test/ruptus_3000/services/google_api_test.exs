defmodule Ruptus3000.GoogleApiTest do
  use ExUnit.Case, async: true
  alias Ruptus3000.Services.GoogleApi

  @start_coordinates %{latitude: 33.81235029151803, longitude: -117.91837280484145}
  @end_coordinates %{latitude: 34.13824110217347, longitude: -118.3533032001647}

  test "makes a successful request for route" do
    assert {:ok, %{"status" => ok, "body" => _body}} = GoogleApi.request_route(@start_coordinates, @end_coordinates)
  end
end
