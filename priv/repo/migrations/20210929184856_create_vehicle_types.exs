defmodule Ruptus3000.Repo.Migrations.CreateVehicleTypes do
  use Ecto.Migration

  def change do
    create table(:vehicle_types) do
      add :label, :string
      add :max_range, :integer
      add :priority_range_start, :integer
      add :priority_range_end, :integer

      timestamps()
    end
  end
end
