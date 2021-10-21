# RUPTUS3000

To start Ruptus3000 server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start the server with `iex -S mix phx.server`

Now you can acces the dashboard through [`localhost:4000`](http://localhost:4000) from your browser and register.
To start executing API requests you need to create your API Token Credential through the dashboard.


## ENDPOINTS

#### ◆ /api/v1/delivery/route

#### METHOD
`POST`

#### URL PARAMS
**Required**
`apikey=[string]`

**Optional**
`force=[true/false/boolean]`
force=true will try to ignore as many errors in the payload as possible, and will not raise an error if you don't pass request body params that are semi-required.

* #### REQUEST BODY
| Name              | Required | Data Type        | Description                        |
|-------------------|----------|------------------|------------------------------------|
| drivers           | required | Array of objects | List of drivers                    |
| collect_point     | required | Object           | Data about collect point           |
| delivery_point    | required | Object           | Data about delivery point          |
| max_delivery_time | required | Float/Integer    | Maximum time to deliver in minutes |

##### DRIVERS OBJECT

| Name                   | Required       | Data Type | Description                    |
|------------------------|----------------|-----------|--------------------------------|
| vehicle                | required       | String    | Vehicle type string name       |
| localization           | required       | Object    | Localization object            |
| localization.latitude  | required       | Float     | Driver's latitude position     |
| localization.longitude | required       | Float     | Driver's longitude position    |
| id                     | semi-optional* | Integer   | Driver's external id           |
| index                  | semi-optional* | Integer   | Driver's position in the array |
| full_name              | semi-optional* | String    | Driver's name                  |

##### COLLECT_POINT/DELIVERY_POINT OBJECT

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

**/* Semi-Optional parameters are not going to raise an error if param force is true.**

<details>
 <summary>EXAMPLE</summary>
   ```json
   {
     "drivers": [
       {
         "id": 76,
         "index": 1,
         "full_name": "Samuel",
         "localization": {
           "latitude": -22.923327310307062,
           "longitude": -43.23326366318878
         },
         "vehicle": "motorcycle"
       },
       {
         "id": 14,
         "index": 1,
         "full_name": "João",
         "localization": {
           "latitude": -22.923327310307062,
           "longitude": -43.23326366318878
         },
         "vehicle": "motorcycle"
       },
       {
         "id": 55,
         "index": 3,
         "full_name": "Ana",
         "localization": {
           "latitude": -22.923327310307062,
           "longitude": -43.23326366318878
         },
         "vehicle": "bike"
       },
       {
         "id": 40,
         "index": 1,
         "full_name": "Beltrão",
         "localization": {
           "latitude": -22.918138967498326,
           "longitude": -43.23961310086657
         },
         "vehicle": "motorcycle"
       }
     ],
     "collect_point": {
       "address": {
         "street": "Av. Maracanã",
         "number": "975",
         "complement": "",
         "neighborhood": "Tijuca",
         "city": "Rio de Janeiro",
         "state": "RJ",
         "zip_code": "20540-102"
       },
       "localization": {
         "latitude": -22.921751902903843,
         "longitude": -43.23475984616638
       }
     },
     "delivery_point": {
       "address": {
         "street": "R. Pinto Guedes",
         "number": "1266",
         "complement": "Apt. 503",
         "neighborhood": "Tijuca",
         "city": "Rio de Janeiro",
         "state": "RJ",
         "zip_code": "82510-280"
       },
       "localization": {
         "latitude": -22.91615253503137,
         "longitude": -43.24802963499768
       },
       "customer_name": "Ciclana de Tal"
     },
     "max_delivery_time": 25.5
   }
   ```
</details>
<hr></hr>

#### ◆ SUCCESS RESPONSE

 **Code:** 200 <br />
| Name                                   | Data Type | Description                                 |
|----------------------------------------|-----------|---------------------------------------------|
| route                                  | Object    | Driver's route informations                 |
| route.full_route                       | Object    | Driver's full route values                  |
| route.full_route.distance              | Float     | Full route distance in kilometers (KM)      |
| route.full_route.duration              | Float     | Full route duration in minutes              |
| route.full_route.polyline              | String    | Full route polyline encoded                 |
| route.to_collect_point                 | Object    | From driver's localization to collect_point localization values                  |
| route.to_collect_point.distance        | Float     | To collect point distance in kilometers (KM)|
| route.to_collect_point.duration        | Float     | To collect point duration in minutes        |
| route.to_collect_point.polyline        | String    | To collect point polyline encoded           |
| route.to_collect_point.localization           | Object    | Collect point localization              |
| route.to_collect_point.localization.latitude  | Float     | Collect point latitude                  |
| route.to_collect_point.localization.longitude | Float     | Collect point longitude                 |
| route.to_delivery_point                 | Object    | From collect_point to delivery_point localization values                  |
| route.to_delivery_point.distance        | Float     | To delivery point distance in kilometers (KM)|
| route.to_delivery_point.duration        | Float     | To delivery point duration in minutes        |
| route.to_delivery_point.polyline        | String    | To delivery point polyline encoded           |
| route.to_delivery_point.localization           | Object    | Delivery point localization              |
| route.to_delivery_point.localization.latitude  | Float     | Delivery point latitude                  |
| route.to_delivery_point.localization.longitude | Float     | Delivery point longitude                 |
| selected_driver                        | Object    | Selected driver's information               |
| selected_driver.full_name              | String    | Selected driver's full_name (if provived)   |
| selected_driver.id                     | Integer   | Selected driver's external id (if provived) |
| selected_driver.localization           | Object    | Selected driver's localization              |
| selected_driver.localization.latitude  | Float     | Selected driver's latitude                  |
| selected_driver.localization.longitude | Float     | Selected driver's longitude                 |

<details>
 <summary>EXAMPLE</summary>

  ```json
  {
      "route": {
          "full_route": {
              "distance": 3.119,
              "duration": 12.383333333333333,
              "polyline": "xe|jCz~zfGpAnCt@|AT\\|D`G{@xAqAWyAWsCSKA?KAMg@_BSa@e@q@WSYMWGa@EYAa@DC???k@JWDGHMPOZQd@?LBX@f@JFVJ`@NdANtCV~@FzARzAJt@HbBp@jAn@p@h@dC~BzBxBpCjChC~B`BxAtDlDnFbF`@`@`@RlCnALJ@HANEJIBIFy@d@sDpBN`@Zr@lBpEpA~Cx@lBpH_Ez@e@GO"
          },
          "to_collect_point": {
              "distance": 0.801,
              "duration": 4.1,
              "localization": {
                  "latitude": -22.921751902903843,
                  "longitude": -43.23475984616638
              },
              "polyline": "xe|jCz~zfGpAnCt@|AT\\|D`G{@xAqAWyAWsCSKA?KAMg@_BSa@e@q@WSYMWGa@EYAa@DC?"
          },
          "to_delivery_point": {
              "distance": 2.318,
              "duration": 8.283333333333333,
              "localization": {
                  "latitude": -22.933598671758777,
                  "longitude": -43.24542779150259
              },
              "polyline": "|{{jCbh{fGk@JWDGHMPOZQd@?LBX@f@JFVJ`@NdANtCV~@FzARzAJt@HbBp@jAn@p@h@dC~BzBxBpCjChC~B`BxAtDlDnFbF`@`@`@RlCnALJ@HANEJIBIFy@d@sDpBN`@Zr@lBpEpA~Cx@lBpH_Ez@e@GO"
          }
      },
      "selected_driver": {
          "full_name": "João",
          "id": 14,
          "localization": {
              "latitude": -22.923327310307062,
              "longitude": -43.23326366318878
          }
      }
  }
  ```

</details>

#### ◆ ERROR RESPONSE

 **Code:** 422 Unprocessable Entity<br />
 Malformed request body.
| Name              | Data Type        | Description                    |
|-------------------|------------------|--------------------------------|
| errors            | array of objects | List of errors                 |
| errors[0].message | String           | Error message                  |
| errors[0].target  | String           | JSON schema error localization |

<details>
 <summary>EXAMPLE</summary>

  ```json
 {
    "errors": [
        {
            "message": "Required property localization was not present.",
            "target": "#/drivers/0"
        }
    ]
}
  ```

</details>


