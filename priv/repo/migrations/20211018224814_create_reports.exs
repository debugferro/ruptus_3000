defmodule Ruptus3000.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :to_collect_distance, :float
      add :to_collect_duration, :float
      add :to_collect_polyline, :text
      add :to_deliver_distance, :float
      add :to_deliver_duration, :float
      add :to_deliver_polyline, :text
      add :full_polyline, :text
      add :to_collect_localization, {:array, :float}
      add :to_deliver_localization, {:array, :float}
      add :driver_localization, {:array, :float}
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:reports, [:driver_id])
  end
end
