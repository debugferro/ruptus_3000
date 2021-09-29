defmodule Ruptus3000.VehicleTest do
  use Ruptus3000.DataCase

  alias Ruptus3000.Vehicle

  describe "vehicle_types" do
    alias Ruptus3000.Vehicle.VehicleType

    import Ruptus3000.VehicleFixtures

    @invalid_attrs %{label: nil, max_range: nil, priority_range_end: nil, priority_range_start: nil}

    test "list_vehicle_types/0 returns all vehicle_types" do
      vehicle_type = vehicle_type_fixture()
      assert Vehicle.list_vehicle_types() == [vehicle_type]
    end

    test "get_vehicle_type!/1 returns the vehicle_type with given id" do
      vehicle_type = vehicle_type_fixture()
      assert Vehicle.get_vehicle_type!(vehicle_type.id) == vehicle_type
    end

    test "create_vehicle_type/1 with valid data creates a vehicle_type" do
      valid_attrs = %{label: "some label", max_range: 42, priority_range_end: 42, priority_range_start: 42}

      assert {:ok, %VehicleType{} = vehicle_type} = Vehicle.create_vehicle_type(valid_attrs)
      assert vehicle_type.label == "some label"
      assert vehicle_type.max_range == 42
      assert vehicle_type.priority_range_end == 42
      assert vehicle_type.priority_range_start == 42
    end

    test "create_vehicle_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicle.create_vehicle_type(@invalid_attrs)
    end

    test "update_vehicle_type/2 with valid data updates the vehicle_type" do
      vehicle_type = vehicle_type_fixture()
      update_attrs = %{label: "some updated label", max_range: 43, priority_range_end: 43, priority_range_start: 43}

      assert {:ok, %VehicleType{} = vehicle_type} = Vehicle.update_vehicle_type(vehicle_type, update_attrs)
      assert vehicle_type.label == "some updated label"
      assert vehicle_type.max_range == 43
      assert vehicle_type.priority_range_end == 43
      assert vehicle_type.priority_range_start == 43
    end

    test "update_vehicle_type/2 with invalid data returns error changeset" do
      vehicle_type = vehicle_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicle.update_vehicle_type(vehicle_type, @invalid_attrs)
      assert vehicle_type == Vehicle.get_vehicle_type!(vehicle_type.id)
    end

    test "delete_vehicle_type/1 deletes the vehicle_type" do
      vehicle_type = vehicle_type_fixture()
      assert {:ok, %VehicleType{}} = Vehicle.delete_vehicle_type(vehicle_type)
      assert_raise Ecto.NoResultsError, fn -> Vehicle.get_vehicle_type!(vehicle_type.id) end
    end

    test "change_vehicle_type/1 returns a vehicle_type changeset" do
      vehicle_type = vehicle_type_fixture()
      assert %Ecto.Changeset{} = Vehicle.change_vehicle_type(vehicle_type)
    end
  end
end
