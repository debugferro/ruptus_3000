defmodule Ruptus3000.Delivery.Report do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Poison.Encoder, only: [:to_collect_distance,
  :to_collect_duration,
  :to_collect_polyline,
  :to_deliver_distance,
  :to_deliver_duration,
  :to_deliver_polyline,
  :full_polyline,
  :to_collect_localization,
  :to_deliver_localization,
  :driver_localization,
  :driver_id]}
  schema "reports" do
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
    belongs_to :user, Ruptus3000.Users.User
    has_many :rejected_drivers, Ruptus3000.Delivery.RejectedDriver

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [
      :to_collect_distance,
      :to_collect_duration,
      :to_collect_polyline,
      :to_deliver_distance,
      :to_deliver_duration,
      :to_deliver_polyline,
      :full_polyline,
      :to_collect_localization,
      :to_deliver_localization,
      :driver_localization,
      :driver_id,
      :user_id
    ])
    |> validate_required([
      :to_collect_distance,
      :to_collect_duration,
      :to_collect_polyline,
      :to_deliver_distance,
      :to_deliver_duration,
      :to_deliver_polyline,
      :full_polyline,
      :to_collect_localization,
      :to_deliver_localization,
      :driver_localization,
      :driver_id
    ])
  end
end
