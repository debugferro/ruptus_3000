defmodule Ruptus3000.VehicleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ruptus3000.Vehicle` context.
  """

  @doc """
  Generate a vehicle_type.
  """
  def vehicle_type_fixture(attrs \\ %{}) do
    {:ok, vehicle_type} =
      attrs
      |> Enum.into(%{
        label: "some label",
        max_range: 42,
        priority_range_end: 42,
        priority_range_start: 42
      })
      |> Ruptus3000.Vehicle.create_vehicle_type()

    vehicle_type
  end
end
