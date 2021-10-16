defmodule Ruptus3000.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false
  alias Ruptus3000.Repo

  alias Ruptus3000.Users.User
  alias Ruptus3000.Users.ApiCredentials
  alias Ruptus3000.Token

  def list_user_api_credentials(user_id) do
    Repo.get(User, user_id)
    |> Ecto.assoc(:api_credentials)
    |> Repo.all()
  end

  def create_api_credentials(attrs \\ %{}) do
    %ApiCredentials{}
    |> ApiCredentials.changeset(attrs)
    |> Repo.insert()
  end

  def build_credentials(user, params) do
    params
    |> Map.put("user_id", user.id)
    |> Map.put("token", Token.generate(user.id))
  end

  def get_api_credential(id) do
    case Repo.get(ApiCredentials, id) do
      nil -> :not_found
      credential -> {:ok, credential}
    end
  end

  def check_credential_token(token, user_id) do
    case from(c in ApiCredentials, where: c.user_id == ^user_id and c.token == ^token)
         |> Repo.one() do
      nil -> :not_found
      token -> {:ok, token}
    end
  end

  def delete_api_credential(api_credential, user_id) do
    case is_authorized?(api_credential.user_id, user_id) do
      true ->
        Repo.delete(api_credential)
        :ok
      false -> :unauthorized
    end
  end

  def update_api_credential(%ApiCredentials{} = api_credential, attrs) do
    api_credential
    |> ApiCredentials.changeset(attrs)
    |> Repo.update()
  end

  def is_authorized?(api_credential_user_id, user_id), do: api_credential_user_id == user_id
end
