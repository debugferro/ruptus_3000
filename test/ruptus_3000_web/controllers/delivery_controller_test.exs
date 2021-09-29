defmodule Ruptus3000Web.Api.V1.DeliveryControllerTest do
  use Ruptus3000Web.ConnCase

  test "A successful POST /api/v1/delivery/route response has all necessary json keys", %{conn: conn} do
    conn = post(conn, "/api/v1/delivery/route")

    assert %{ "delivery_person" => %{"full_name" => _, "id" => _},
              "estimated_time" => %{
                "full_route" => _,
                "to_collect_point" => _,
                "to_delivery_point" => _
              },
              "route_polyline" => _
            } = json_response(conn, 200)
  end
end
