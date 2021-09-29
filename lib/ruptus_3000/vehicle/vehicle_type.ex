defmodule Ruptus3000.Vehicle.VehicleType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_types" do
    field :label, :string
    field :max_range, :integer
    field :priority_range_end, :integer
    field :priority_range_start, :integer

    timestamps()
  end

  @doc false
  def changeset(vehicle_type, attrs) do
    vehicle_type
    |> cast(attrs, [:label, :max_range, :priority_range_start, :priority_range_end])
    |> validate_required([:label, :max_range, :priority_range_start, :priority_range_end])
  end
end
