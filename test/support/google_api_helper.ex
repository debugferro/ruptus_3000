defmodule Ruptus3000.GoogleApiHelper do
  @payload {:ok, %{
    "routes" => [
      %{
        "legs" => [
          %{
            "distance" => %{"text" => "35.9 mi", "value" => 57811},
            "duration" => %{"text" => "48 mins", "value" => 2871},
          }
        ],
        "overview_polyline" => %{
          "points" => "polyline"
        },
      }
    ]
  }}
  @filter_response %{
    distance: 57.811,
    duration: 2871,
    polyline: "polyline"
  }
  @ok_body "{\n   \"status\" : \"OK\"\n}\n"
  @error_body "{\n   \"error_message\" : \"Could not route\",\n \"status\" : \"NO_ROUTE\" \n}\n"

  def common_response(), do: @payload
  def filter_response(), do: @filter_response
  def non_decoded_body(:successful), do: @ok_body
  def non_decoded_body(:unsuccessful), do: @error_body
end
