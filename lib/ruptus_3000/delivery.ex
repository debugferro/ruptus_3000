defmodule Ruptus3000.Delivery do
  @moduledoc """
  The Delivery context.
  """

  import Ecto.Query, warn: false
  alias Ruptus3000.Repo

  alias Ruptus3000.Delivery.{Driver, Report, RejectedDriver}
  alias Ruptus3000.Users

  def create_rejected_driver(attrs \\ %{}) do
    %RejectedDriver{}
    |> RejectedDriver.changeset(attrs)
    |> Repo.insert()
  end

  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  def create_driver(attrs \\ %{}) do
    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  def find_driver_where(keywords) do
    Driver
    |> where(^keywords)
    |> Repo.all()
  end

  def get_report(id), do: Repo.get(Report, id) |> Repo.preload(:driver) |> Repo.preload([rejected_drivers: [:driver]])

  def create_or_find_driver(driver) do
    case find_driver_where(external_id: driver_id(driver)) do
      [] -> build_driver_attrs(driver) |> create_driver() |> return_driver()
      [driver | _tail] -> driver
    end
  end

  defp return_driver({:ok, driver}), do: driver
  defp driver_id(%{id: id}), do: id
  defp driver_id(%{"id" => id}), do: id

  defp build_driver_attrs(%{id: id, full_name: full_name}) do
    %{
      external_id: id,
      full_name: full_name
    }
  end

  defp build_driver_attrs(%{"id" => id, "full_name" => full_name}) do
    %{
      external_id: id,
      full_name: full_name
    }
  end
end
