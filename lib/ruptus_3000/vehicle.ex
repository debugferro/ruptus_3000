defmodule Ruptus3000.Vehicle do
  @moduledoc """
  The Vehicle context.
  """

  import Ecto.Query, warn: false
  alias Ruptus3000.Repo

  alias Ruptus3000.Vehicle.VehicleType

  @doc """
  Returns the list of vehicle_types.

  ## Examples

      iex> list_vehicle_types()
      [%VehicleType{}, ...]

  """
  def list_vehicle_types do
    Repo.all(VehicleType)
  end

  @doc """
  Gets a single vehicle_type.

  Raises `Ecto.NoResultsError` if the Vehicle type does not exist.

  ## Examples

      iex> get_vehicle_type!(123)
      %VehicleType{}

      iex> get_vehicle_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle_type!(id), do: Repo.get!(VehicleType, id)

  @doc """
  Creates a vehicle_type.

  ## Examples

      iex> create_vehicle_type(%{field: value})
      {:ok, %VehicleType{}}

      iex> create_vehicle_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle_type(attrs \\ %{}) do
    %VehicleType{}
    |> VehicleType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle_type.

  ## Examples

      iex> update_vehicle_type(vehicle_type, %{field: new_value})
      {:ok, %VehicleType{}}

      iex> update_vehicle_type(vehicle_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle_type(%VehicleType{} = vehicle_type, attrs) do
    vehicle_type
    |> VehicleType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle_type.

  ## Examples

      iex> delete_vehicle_type(vehicle_type)
      {:ok, %VehicleType{}}

      iex> delete_vehicle_type(vehicle_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle_type(%VehicleType{} = vehicle_type) do
    Repo.delete(vehicle_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle_type changes.

  ## Examples

      iex> change_vehicle_type(vehicle_type)
      %Ecto.Changeset{data: %VehicleType{}}

  """
  def change_vehicle_type(%VehicleType{} = vehicle_type, attrs \\ %{}) do
    VehicleType.changeset(vehicle_type, attrs)
  end

  def get_vehicles_by_max_range(distance) do
    from(v in VehicleType, where: v.max_range >= ^distance)
    |> Repo.all()
  end

  def build_label_list(vehicles) do
    Enum.map(vehicles, fn vehicle -> vehicle.label end)
  end
end
