defmodule Ruptus3000.Repo.Migrations.CreateVehicleTypes do
  use Ecto.Migration

  def change do
    create table(:vehicle_types) do
      add :label, :string
      add :max_range, :float
      add :priority_range_start, :float
      add :priority_range_end, :float
      timestamps()
    end
  end
end
