defmodule Ruptus3000.HandlersHelpers do

  @motorcycle %{
    label: "motorcycle",
    max_range: 30.0,
    priority_range_end: 30.0,
    priority_range_start: 2.1,
  }

  @bike %{
    label: "bike",
    max_range: 2,
    priority_range_start: 0,
    priority_range_end: 2
  }

  @multiple_vehicles_query [@bike, @motorcycle]

  @result %{
    to_delivery_point: %{
      duration: 10,
      distance: 10
    }
  }

  @basic_biker %{
    "vehicle" => "bike",
    to_collect_point: %{distance: 1}
  }

  @basic_motorcycle %{
    "vehicle" => "motorcycle",
    to_collect_point: %{distance: 1},
  }

  @vehicle_list %{
    "bike" => %{
      max_range: 2,
      priority_range_start: 0,
      priority_range_end: 2
    },
    "motorcycle" => %{
      max_range: 30,
      priority_range_start: 2.1,
      priority_range_end: 30
    }
  }

  def multiple_vehicles_query(), do: @multiple_vehicles_query
  def fake_result(), do: @result
  def vehicle_list(), do: @vehicle_list
  def basic_motorcycle(), do: @basic_motorcycle
  def basic_biker(), do: @basic_biker
end
