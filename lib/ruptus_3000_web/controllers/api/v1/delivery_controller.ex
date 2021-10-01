defmodule Ruptus3000Web.Api.V1.DeliveryController do
  use Ruptus3000Web, :controller

  alias Ruptus3000.Driver.Selector

  def route(conn, params) do
    {:ok, _, response} = Selector.start(params)
    render(conn, "route.json", %{result: response})
  end
end
