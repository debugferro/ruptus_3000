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
| Name              | Required | Data Type        | Description                        |
|-------------------|----------|------------------|------------------------------------|
| drivers           | required | Array of objects | List of drivers                    |
| collect_point     | required | Object           | Data about collect point           |
| delivery_point    | required | Object           | Data about delivery point          |
| max_delivery_time | required | Float/Integer    | Maximum time to deliver in minutes |

#### DRIVERS OBJECT

| Name                   | Required       | Data Type | Description                    |
|------------------------|----------------|-----------|--------------------------------|
| vehicle                | required       | String    | Vehicle type string name       |
| localization           | required       | Object    | Localization object            |
| localization.latitude  | required       | Float     | Driver's latitude position     |
| localization.longitude | required       | Float     | Driver's longitude position    |
| id                     | semi-optional* | Integer   | Driver's external id           |
| index                  | semi-optional* | Integer   | Driver's position in the array |
| full_name              | semi-optional* | String    | Driver's name                  |

#### COLLECT_POINT/DELIVERY_POINT OBJECT

| Name                   | Required | Data Type | Description                             |
|------------------------|----------|-----------|-----------------------------------------|
| localization           | required | Object    | Localization object                     |
| localization.latitude  | required | Float     | Driver's latitude position              |
| localization.longitude | required | Float     | Driver's longitude position             |
| address                | optional | Object    | Deliver waypoint address specifications |
| address.street         | optional | String    | Street name                             |
| address.number         | optional | String    | Waypoint house/building number          |
| address.complement     | optional | String    | Waypoint house/building complement      |
| address.neighborhood   | optional | String    | Neighborhood name                       |
| address.city           | optional | String    | City name                               |
| address.state          | optional | String    | State abbreviation                      |
| address.zip_code       | optional | String    | Waypoint zip code                       |
