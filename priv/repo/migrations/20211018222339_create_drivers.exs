defmodule Ruptus3000.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :external_id, :integer
      add :full_name, :string

      timestamps()
    end
  end
end
