defmodule Ruptus3000Web do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Ruptus3000Web, :controller
      use Ruptus3000Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def validate do
    quote do
      import Plug.Conn
      use Phoenix.Controller
      def init(options), do: options

      def call(conn, key) do
        case __MODULE__.validate_schema(schema() |> IO.inspect(label: "SCHEMA"), conn) do
          :ok ->
            conn

          {:error, errors} ->
            IO.inspect(errors, label: "ERRORS")

            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: __MODULE__.build_errors(errors)})
            |> halt()
        end
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: Ruptus3000Web

      import Plug.Conn
      import Ruptus3000Web.Gettext
      alias Ruptus3000Web.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/ruptus_3000_web/templates",
        namespace: Ruptus3000Web

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {Ruptus3000Web.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Ruptus3000Web.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import Ruptus3000Web.ErrorHelpers
      import Ruptus3000Web.Gettext
      alias Ruptus3000Web.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
