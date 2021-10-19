defmodule Ruptus3000.Delivery.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :external_id, :integer
    field :full_name, :string
    has_many :reports, Ruptus3000.Delivery.Report
    timestamps()
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:external_id, :full_name])
    |> validate_required([:external_id, :full_name])
  end
end
