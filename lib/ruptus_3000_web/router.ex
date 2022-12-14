defmodule Ruptus3000Web.Router do
  use Ruptus3000Web, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Ruptus3000Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected_api do
    plug Ruptus3000Web.Middlewares.ApiAuthentication
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", Ruptus3000Web do
    pipe_through [:protected, :browser]

    # get "/", PageController, :index
    resources "/", ApiCredentialsController, only: [:index]
    resources "/api_credentials", ApiCredentialsController, except: [:index]
    live "/reports", ReportsLive.Index, as: :report_index
    resources "/vehicle_type", VehicleTypeController
  end

  scope "/api/v1", Ruptus3000Web.Api.V1 do
    pipe_through [:api, :protected_api]

    post "/delivery/route", DeliveryController, :route
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: Ruptus3000Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
