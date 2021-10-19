defmodule Ruptus3000.Delivery do
  @moduledoc """
  The Delivery context.
  """

  import Ecto.Query, warn: false
  alias Ruptus3000.Repo

  alias Ruptus3000.Delivery.{Driver, Report}

  @doc """
    Parses data from handle_routing handlers and create report record.
  """
  def create_report_from_result(%{
        route: %{
          to_collect_point: collect_point,
          to_delivery_point: delivery_point,
          full_route: full_route
        },
        selected_driver: driver
      }) do
    %{
      to_collect_distance: collect_point.distance,
      to_collect_duration: collect_point.duration,
      to_collect_polyline: collect_point.polyline,
      to_collect_localization: [
        collect_point.localization["latitude"],
        collect_point.localization["longitude"]
      ],
      to_deliver_distance: delivery_point.distance,
      to_deliver_duration: delivery_point.duration,
      to_deliver_polyline: delivery_point.polyline,
      to_deliver_localization: [
        delivery_point.localization["latitude"],
        delivery_point.localization["longitude"]
      ],
      full_polyline: full_route.polyline,
      driver_localization: [driver.localization["latitude"], driver.localization["longitude"]],
      driver_id: create_or_find_driver(driver) |> Map.get(:id)
    }
    |> create_report()
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

  def get_report(id), do: Repo.get(Report, id) |> Repo.preload(:driver)

  def create_or_find_driver(driver) do
    case find_driver_where(external_id: driver[:id]) do
      [] -> build_driver_attrs(driver) |> create_driver() |> return_driver()
      [driver | _tail] -> driver
    end
  end

  defp return_driver({:ok, driver}), do: driver

  defp build_driver_attrs(driver) do
    %{
      external_id: driver[:id],
      full_name: driver[:full_name]
    }
  end
end
