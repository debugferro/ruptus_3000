defmodule Ruptus3000Web.VehicleTypeController do
  use Ruptus3000Web, :controller

  alias Ruptus3000.Vehicle
  alias Ruptus3000.Vehicle.VehicleType

  def index(conn, _params) do
    vehicle_types = Vehicle.list_vehicle_types()
    render(conn, "index.html", vehicle_types: vehicle_types)
  end

  def new(conn, _params) do
    changeset = Vehicle.change_vehicle_type(%VehicleType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"vehicle_type" => vehicle_type_params}) do
    case Vehicle.create_vehicle_type(vehicle_type_params) do
      {:ok, vehicle_type} ->
        conn
        |> put_flash(:info, "Vehicle type created successfully.")
        |> redirect(to: Routes.vehicle_type_path(conn, :show, vehicle_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle_type = Vehicle.get_vehicle_type!(id)
    render(conn, "show.html", vehicle_type: vehicle_type)
  end

  def edit(conn, %{"id" => id}) do
    vehicle_type = Vehicle.get_vehicle_type!(id)
    changeset = Vehicle.change_vehicle_type(vehicle_type)
    render(conn, "edit.html", vehicle_type: vehicle_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "vehicle_type" => vehicle_type_params}) do
    vehicle_type = Vehicle.get_vehicle_type!(id)

    case Vehicle.update_vehicle_type(vehicle_type, vehicle_type_params) do
      {:ok, vehicle_type} ->
        conn
        |> put_flash(:info, "Vehicle type updated successfully.")
        |> redirect(to: Routes.vehicle_type_path(conn, :show, vehicle_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", vehicle_type: vehicle_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle_type = Vehicle.get_vehicle_type!(id)
    {:ok, _vehicle_type} = Vehicle.delete_vehicle_type(vehicle_type)

    conn
    |> put_flash(:info, "Vehicle type deleted successfully.")
    |> redirect(to: Routes.vehicle_type_path(conn, :index))
  end
end
