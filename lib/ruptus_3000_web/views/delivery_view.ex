defmodule Ruptus3000Web.Api.V1.DeliveryView do
  use Ruptus3000Web, :view

  def render("route.json", payload) do
    # %{
    #   delivery_person: %{
    #     full_name: "fulaninha",
    #     id: payload.id
    #   },
    #   estimated_time: %{
    #     full_route: 1000,
    #     to_collect_point: 500,
    #     to_delivery_point: 500
    #   },
    #   route_polyline: "3343465467%$#!@!#!$&**OÌPOÇP^^"
    # }
    %{result: payload.result}
  end
end
