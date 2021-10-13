defmodule Ruptus3000.HandlersHelpers do

  @vehicle_query [
    %{
      label: "motorcycle",
      max_range: 30.0,
      priority_range_end: 10.0,
      priority_range_start: 2.0,
    }
  ]

  @result %{
    to_delivery_point: %{
      duration: 10,
      distance: 10
    }
  }

  def vehicle_query(), do: @vehicle_query
  def fake_result(), do: @result
end
