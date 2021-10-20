defmodule Ruptus3000.Repo.Migrations.CreateRejectedDrivers do
  use Ecto.Migration

  def change do
    create table(:rejected_drivers) do
      add :message, :string
      add :error_type, :string
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :report_id, references(:reports, on_delete: :nothing)

      timestamps()
    end

    create index(:rejected_drivers, [:driver_id])
    create index(:rejected_drivers, [:report_id])
  end
end
