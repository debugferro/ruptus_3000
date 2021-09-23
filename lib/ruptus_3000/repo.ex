defmodule Ruptus3000.Repo do
  use Ecto.Repo,
    otp_app: :ruptus_3000,
    adapter: Ecto.Adapters.Postgres
end
