defmodule Ruptus3000.Token do
  alias Ruptus3000.Users
  @salt "api credential"

  def generate(user_id) do
    Phoenix.Token.sign(Ruptus3000Web.Endpoint, @salt, user_id)
  end

  def check_validity(token) do
    with {:ok, user_id} <- Phoenix.Token.verify(Ruptus3000Web.Endpoint, @salt, token),
         {:ok, _token} <- Users.check_credential_token(token, user_id) do
      :authorized
    else
      _any -> :not_authorized
    end
  end
end
