defmodule Ruptus3000Web.Live.Credentials do
  @moduledoc "Authentication helper functions"

  alias Ruptus3000.Users.User
  alias Pow.Store.CredentialsCache

  @doc """
  Retrieves the currently-logged-in user from the Pow credentials cache.
  """
  @spec get_user(
          socket :: Socket.t(),
          session :: map(),
          config :: keyword()
        ) :: %User{} | nil
  def get_user(socket, session, config \\ [otp_app: :ruptus_3000])

  def get_user(socket, %{"ruptus_3000_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
          {user, _metadata} <- CredentialsCache.get([backend: Pow.Store.Backend.EtsCache], token) do
      {:ok, user}
    else
      _any -> {:error, :not_authenticated}
    end
  end

  def get_user(_, _, _), do: nil
end
