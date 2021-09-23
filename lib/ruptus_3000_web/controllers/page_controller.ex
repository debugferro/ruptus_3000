defmodule Ruptus3000Web.PageController do
  use Ruptus3000Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
