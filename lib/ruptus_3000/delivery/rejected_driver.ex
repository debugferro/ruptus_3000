defmodule Ruptus3000.Delivery.RejectedDriver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rejected_drivers" do
    field :error_type, :string
    field :message, :string
    belongs_to :driver, Ruptus3000.Delivery.Driver
    belongs_to :report, Ruptus3000.Delivery.Report

    timestamps()
  end

  @doc false
  def changeset(rejected_driver, attrs) do
    rejected_driver
    |> cast(attrs, [:message, :error_type, :report_id, :driver_id])
    |> validate_required([:message, :error_type, :report_id, :driver_id])
  end
end
