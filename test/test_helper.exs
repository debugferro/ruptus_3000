Mimic.copy(Ruptus3000.Services.GoogleApi)
Mimic.copy(HTTPoison)
Mimic.copy(Ruptus3000.Driver.Helpers)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Ruptus3000.Repo, :manual)
