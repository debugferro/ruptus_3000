defmodule Ruptus3000.Services.GoogleApi do
  alias HTTPoison
  alias Plug.Conn.Status
  alias Ruptus3000.Driver.Helpers
  @behaviour Ruptus3000.Services.RoutingApiBehaviour
  @api_key Application.get_env(:ruptus_3000, :routing_api_key)
  @base_url "https://maps.googleapis.com"
  @route_url "/maps/api/directions/json"

  @spec request_route(%{:latitude => float() | String.t(), :longitude => float() | String.t()}, %{
          :latitude => float() | String.t(),
          :longitude => float() | String.t()
        }) ::
          {:ok, %{required(String.t()) => any()}}
          | {:error, String.t(), String.t()}
          | {:error, atom()}
  def request_route(start_point, end_point) do
    params = %{
      key: @api_key,
      origin: build_coordinates(start_point),
      destination: build_coordinates(end_point)
    }

    case execute_request(params) do
      %{body: body, status_code: 200} -> decode_response(body) |> build_response()
      %{status_code: status_code} -> build_error_response(status_code)
    end
  end

  @spec filter_response(map()) :: %{
    distance: String.t() | integer() | float(),
    duration: String.t() | integer(),
    polyline: String.t()
  }
  def filter_response(response) do
    route = response["routes"] |> get_route(0)
    main_leg = route["legs"] |> get_leg(0)

    %{
      distance: Helpers.meters_to_km(main_leg["distance"]["value"]),
      duration: Helpers.seconds_to_minutes(main_leg["duration"]["value"]),
      polyline: route["overview_polyline"]["points"]
    }
  end

  defp execute_request(params) do
    HTTPoison.get!(full_url(), [], params: params)
  end

  defp get_route(route, index), do: Enum.at(route, index)
  defp get_leg(legs, index), do: Enum.at(legs, index)
  defp decode_response(response), do: response |> Poison.decode!()
  defp build_error_response(status_code), do: {:error, Status.reason_atom(status_code)}
  defp build_response(%{"error_message" => message} = body), do: {:error, message, body["status"]}
  defp build_response(%{"status" => "ZERO_RESULTS"} = body), do: {:error, body["status"]}
  defp build_response(%{"status" => "OK"} = body), do: {:ok, body}
  defp build_coordinates(%{latitude: latitude, longitude: longitude}), do: "#{latitude},#{longitude}"
  defp build_coordinates(%{"latitude" => latitude, "longitude" => longitude}),
    do: "#{latitude},#{longitude}"

  defp full_url, do: @base_url <> @route_url
end
