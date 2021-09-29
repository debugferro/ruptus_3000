defmodule Ruptus3000Web.VehicleTypeControllerTest do
  use Ruptus3000Web.ConnCase

  import Ruptus3000.VehicleFixtures

  @create_attrs %{label: "some label", max_range: 42, priority_range_end: 42, priority_range_start: 42}
  @update_attrs %{label: "some updated label", max_range: 43, priority_range_end: 43, priority_range_start: 43}
  @invalid_attrs %{label: nil, max_range: nil, priority_range_end: nil, priority_range_start: nil}

  describe "index" do
    test "lists all vehicle_types", %{conn: conn} do
      conn = get(conn, Routes.vehicle_type_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Vehicle types"
    end
  end

  describe "new vehicle_type" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.vehicle_type_path(conn, :new))
      assert html_response(conn, 200) =~ "New Vehicle type"
    end
  end

  describe "create vehicle_type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.vehicle_type_path(conn, :create), vehicle_type: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.vehicle_type_path(conn, :show, id)

      conn = get(conn, Routes.vehicle_type_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Vehicle type"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.vehicle_type_path(conn, :create), vehicle_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Vehicle type"
    end
  end

  describe "edit vehicle_type" do
    setup [:create_vehicle_type]

    test "renders form for editing chosen vehicle_type", %{conn: conn, vehicle_type: vehicle_type} do
      conn = get(conn, Routes.vehicle_type_path(conn, :edit, vehicle_type))
      assert html_response(conn, 200) =~ "Edit Vehicle type"
    end
  end

  describe "update vehicle_type" do
    setup [:create_vehicle_type]

    test "redirects when data is valid", %{conn: conn, vehicle_type: vehicle_type} do
      conn = put(conn, Routes.vehicle_type_path(conn, :update, vehicle_type), vehicle_type: @update_attrs)
      assert redirected_to(conn) == Routes.vehicle_type_path(conn, :show, vehicle_type)

      conn = get(conn, Routes.vehicle_type_path(conn, :show, vehicle_type))
      assert html_response(conn, 200) =~ "some updated label"
    end

    test "renders errors when data is invalid", %{conn: conn, vehicle_type: vehicle_type} do
      conn = put(conn, Routes.vehicle_type_path(conn, :update, vehicle_type), vehicle_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Vehicle type"
    end
  end

  describe "delete vehicle_type" do
    setup [:create_vehicle_type]

    test "deletes chosen vehicle_type", %{conn: conn, vehicle_type: vehicle_type} do
      conn = delete(conn, Routes.vehicle_type_path(conn, :delete, vehicle_type))
      assert redirected_to(conn) == Routes.vehicle_type_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.vehicle_type_path(conn, :show, vehicle_type))
      end
    end
  end

  defp create_vehicle_type(_) do
    vehicle_type = vehicle_type_fixture()
    %{vehicle_type: vehicle_type}
  end
end
