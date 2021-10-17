defmodule Ruptus3000Web.ApiCredentialsControllerTest do
  use Ruptus3000Web.ConnCase
  use Mimic

  alias Ruptus3000.Users
  alias Users.{User, ApiCredentials}

  @existing_credential_title "My beautiful token"
  @exiting_credential %ApiCredentials{title: @existing_credential_title, token: "1234", id: 1}
  @create_attrs %{title: "My Token"}
  @invalid_attrs %{title: nil}

  @not_found_msg "API Credential not found"
  @successful_deletion_msg "API Credential deleted successfully"
  @not_authorized_msg "Not authorized"

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 1}
    conn = Pow.Plug.assign_current_user(conn, user, otp_app: :ruptus_3000)
    {:ok, conn: conn}
  end

  describe "index" do
    setup do
      Users
      |> expect(:list_user_api_credentials, fn _ -> [@exiting_credential] end)

      :ok
    end

    test "lists all api_credentials", %{conn: authed_conn} do
      conn = get(authed_conn, Routes.api_credentials_path(authed_conn, :index))
      assert html_response(conn, 200) =~ @existing_credential_title
    end
  end

  describe "new api_credential" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.api_credentials_path(conn, :new))
      assert html_response(conn, 200) =~ "New Api Credential" and "Title"
    end
  end

  describe "create api_credential" do
    setup do
      Users
      |> expect(:create_api_credentials, fn _ -> {:ok, @exiting_credential} end)
      |> expect(:list_user_api_credentials, fn _ -> [@exiting_credential] end)

      :ok
    end

    test "redirects to index when data is valid", %{conn: auth_conn} do
      conn =
        post(auth_conn, Routes.api_credentials_path(auth_conn, :create),
          api_credentials: @create_attrs
        )

      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)

      conn = get(auth_conn, Routes.api_credentials_path(auth_conn, :index))
      assert html_response(conn, 200) =~ @existing_credential_title
    end
  end

  describe "create api_credential unsuccessful" do
    setup do
      Users
      |> expect(:create_api_credentials, fn _ ->
        {:error, ApiCredentials.changeset(%ApiCredentials{}, %{})}
      end)

      :ok
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.api_credentials_path(conn, :create), api_credentials: @invalid_attrs)

      assert html_response(conn, 200) =~ "title" and "submit"
    end
  end

  describe "api_credential successfully found" do
    setup do
      Users
      |> expect(:get_api_credential, fn _ -> {:ok, @exiting_credential} end)
      |> expect(:is_authorized?, fn _, _ -> true end)

      :ok
    end

    test "UPDATE api_credential: it redirects to index when data is valid", %{conn: auth_conn} do
      expect(Users, :update_api_credential, fn _, _ -> {:ok, @exiting_credential} end)

      conn =
        put(auth_conn, Routes.api_credentials_path(auth_conn, :update, 1),
          api_credentials: @create_attrs
        )

      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end

    test "EDIT api_credential: it renders form for editing chosen api_credential", %{conn: conn} do
      conn = get(conn, Routes.api_credentials_path(conn, :edit, 1))
      assert html_response(conn, 200) =~ "</form>" and @existing_credential_title
    end
  end

  describe "when api_credential does not exist" do
    setup do
      Users
      |> expect(:get_api_credential, fn _ -> :not_found end)

      :ok
    end

    test "UPDATE api_credential: it flashes an info and redirect to index", %{conn: auth_conn} do
      conn =
        put(auth_conn, Routes.api_credentials_path(auth_conn, :update, 1),
          api_credentials: @create_attrs
        )

      assert get_flash(conn, :info) == @not_found_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end

    test "EDIT api_credential: it flashes an info and redirect to index", %{conn: conn} do
      conn = get(conn, Routes.api_credentials_path(conn, :edit, 1))
      assert get_flash(conn, :info) == @not_found_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end

    test "DELETE api_credential: it flashes an info and redirect to index", %{conn: conn} do
      conn = delete(conn, Routes.api_credentials_path(conn, :delete, 1))
      assert get_flash(conn, :info) == @not_found_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end
  end

  describe "when api_credential does not authorize current_user" do
    setup do
      Users
      |> expect(:get_api_credential, fn _ -> {:ok, @exiting_credential} end)
      |> expect(:is_authorized?, fn _, _ -> false end)

      :ok
    end

    test "UPDATE api_credential: it flashes an info and redirect to index", %{conn: auth_conn} do
      conn =
        put(auth_conn, Routes.api_credentials_path(auth_conn, :update, 1),
          api_credentials: @create_attrs
        )

      assert get_flash(conn, :info) == @not_authorized_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end

    test "EDIT api_credential: it flashes an info and redirect to index", %{conn: conn} do
      conn = get(conn, Routes.api_credentials_path(conn, :edit, 1))
      assert get_flash(conn, :info) == @not_authorized_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end
  end

  describe "delete api_credential successful" do
    setup do
      Users
      |> expect(:get_api_credential, fn _ -> {:ok, @exiting_credential} end)
      |> expect(:delete_api_credential, fn _, _ -> :ok end)

      :ok
    end

    test "it redirects to index after deletion", %{conn: conn} do
      conn = delete(conn, Routes.api_credentials_path(conn, :delete, 1))
      assert get_flash(conn, :info) == @successful_deletion_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end
  end

  describe "delete api_credential not authorized" do
    setup do
      Users
      |> expect(:get_api_credential, fn _ -> {:ok, @exiting_credential} end)
      |> expect(:delete_api_credential, fn _, _ -> :unauthorized end)

      :ok
    end

    test "it redirects to index and flashes an error", %{conn: conn} do
      conn = delete(conn, Routes.api_credentials_path(conn, :delete, 1))
      assert get_flash(conn, :info) == @not_found_msg
      assert redirected_to(conn) == Routes.api_credentials_path(conn, :index)
    end
  end
end
