Mimic.copy(Ruptus3000.Services.GoogleApi)
Mimic.copy(HTTPoison)
Mimic.copy(Ruptus3000.Routing.Helpers)
Mimic.copy(Ruptus3000.Vehicle)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Ruptus3000.Repo, :manual)
