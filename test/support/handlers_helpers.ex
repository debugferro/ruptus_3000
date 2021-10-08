defmodule Ruptus3000.HandlersHelpers do

  @vehicle_query [
    %{
      label: "motorcycle",
      max_range: 30.0,
      priority_range_end: 10.0,
      priority_range_start: 2.0,
    }
  ]

  @bike_query [
    %{
      label: "bike",
      max_range: 2.0,
      priority_range_end: 2.0,
      priority_range_start: 0.0,
    }
  ]

  @result %{
    drivers: [%{
      "localization" => %{
        "latitude" => 10,
        "longitude" => 10
      }
    }],
    to_delivery_point: %{
      duration: 10,
      distance: 10
    }
  }

  def vehicle_query(), do: @vehicle_query
  def fake_result(), do: @result
end
