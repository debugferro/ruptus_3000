defmodule Ruptus3000.Delivery.Shipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shipments" do
    field :driver_localization, {:array, :float}
    field :full_polyline, :string
    field :to_collect_distance, :float
    field :to_collect_duration, :float
    field :to_collect_localization, {:array, :float}
    field :to_collect_polyline, :string
    field :to_deliver_distance, :float
    field :to_deliver_duration, :float
    field :to_deliver_localization, {:array, :float}
    field :to_deliver_polyline, :string
    belongs_to :driver, Ruptus3000.Delivery.Driver

    timestamps()
  end

  @doc false
  def changeset(shipment, attrs) do
    shipment
    |> cast(attrs, [:to_collect_distance, :to_collect_duration, :to_collect_polyline, :to_deliver_distance, :to_deliver_duration, :to_deliver_polyline, :full_polyline, :to_collect_localization, :to_deliver_localization, :driver_localization, :driver_id])
    |> validate_required([:to_collect_distance, :to_collect_duration, :to_collect_polyline, :to_deliver_distance, :to_deliver_duration, :to_deliver_polyline, :full_polyline, :to_collect_localization, :to_deliver_localization, :driver_localization, :driver_id])
  end
end
