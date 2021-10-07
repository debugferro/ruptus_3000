defmodule Ruptus3000Web.Api.V1.DeliveryView do
  use Ruptus3000Web, :view

  def render("route.json", payload) do
    payload.result
  end
end
