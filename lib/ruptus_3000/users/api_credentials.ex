defmodule Ruptus3000.Users.ApiCredentials do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_credentials" do
    field :token, :string
    field :title, :string
    belongs_to :user, Ruptus3000.Users.User

    timestamps()
  end

  @doc false
  def changeset(api_credentials, attrs) do
    api_credentials
    |> cast(attrs, [:title, :token, :user_id])
    |> validate_required([:title, :token, :user_id])
  end
end
