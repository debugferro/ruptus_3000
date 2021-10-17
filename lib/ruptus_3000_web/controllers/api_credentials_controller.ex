defmodule Ruptus3000Web.ApiCredentialsController do
  use Ruptus3000Web, :controller
  alias Ruptus3000.Users
  alias Ruptus3000.Users.ApiCredentials

  plug Ruptus3000Web.Middlewares.CurrentUser

  def index(conn, _params) do
    api_credentials = Users.list_user_api_credentials(conn.current_user.id)
    render(conn, "index.html", api_credentials: api_credentials)
  end

  def new(conn, _params) do
    changeset = ApiCredentials.changeset(%ApiCredentials{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_credentials" => api_credentials_params}) do
    credentials_params =
      conn.current_user
      |> Users.build_credentials(api_credentials_params)

    case Users.create_api_credentials(credentials_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Credential created")
        |> redirect(to: Routes.api_credentials_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, credential} <- Users.get_api_credential(id),
         true <- Users.is_authorized?(credential.user_id, conn.current_user.id) do
      changeset = ApiCredentials.changeset(credential, %{})
      render(conn, "edit.html", api_credentials: credential, changeset: changeset)
    else
      false -> not_authorized_return(conn)
      :not_found -> not_found_return(conn)
    end
  end

  def update(conn, %{"id" => id, "api_credentials" => %{"title" => title}}) do
    case Users.get_api_credential(id) do
      {:ok, credential} ->

        with true <- Users.is_authorized?(credential.user_id, conn.current_user.id),
             {:ok, _credential} <- Users.update_api_credential(credential, %{title: title}) do
          conn
          |> put_flash(:info, "Credential updated successfully")
          |> redirect(to: Routes.api_credentials_path(conn, :index))
        else
          false ->
            not_authorized_return(conn)

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", api_credentials: credential, changeset: changeset)
        end

      :not_found ->
        not_found_return(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, credential} <- Users.get_api_credential(id),
         :ok <- Users.delete_api_credential(credential, conn.current_user.id) do
      conn
      |> put_flash(:info, "API Credential deleted successfully")
      |> redirect(to: Routes.api_credentials_path(conn, :index))
    else
      _any -> not_found_return(conn)
    end
  end

  defp not_found_return(conn) do
    conn
    |> put_flash(:info, "API Credential not found")
    |> redirect(to: Routes.api_credentials_path(conn, :index))
  end

  defp not_authorized_return(conn) do
    conn
    |> put_flash(:info, "Not authorized")
    |> redirect(to: Routes.api_credentials_path(conn, :index))
  end
end
