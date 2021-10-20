# RUPTUS3000

To start Ruptus3000 server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start the server with `iex -S mix phx.server`

Now you can acces the dashboard through [`localhost:4000`](http://localhost:4000) from your browser and register.
To start executing API requests you need to create your API Token Credential through the dashboard.


## ENDPOINTS

* #### /api/v1/delivery/route

* #### METHOD
`POST`

* #### URL PARAMS
**Required**
`apikey=[string]`

* #### DATA PARAMS
