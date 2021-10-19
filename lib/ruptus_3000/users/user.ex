defmodule Ruptus3000.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    has_many :api_credentials, Ruptus3000.Users.ApiCredentials
    has_many :reports, Ruptus3000.Delivery.Report

    timestamps()
  end
end
