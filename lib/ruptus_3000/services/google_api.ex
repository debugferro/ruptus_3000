defmodule Ruptus3000.Services.GoogleApi do
  alias HTTPoison
  alias Plug.Conn.Status
  @behaviour Ruptus3000.Services.RoutingApi
  @api_key Application.get_env(:ruptus_3000, :routing_api_key)
  @base_url "https://maps.googleapis.com"
  @route_url "/maps/api/directions/json"

  @spec request_route(%{:latitude => float() | String.t(), :longitude => float() | String.t()}, %{
    :latitude => float() | String.t(),
    :longitude => float() | String.t()
  }) :: {:ok, %{required(String.t()) => any()}} | {:error, String.t(), String.t()} | {:error, atom()}

  def request_route(start_point, end_point) do
    params = %{ key: @api_key, origin: build_coordinates(start_point),
                destination: build_coordinates(end_point) }

    case execute_request(params) do
      %{body: body, status_code: 200} -> decode_response(body) |> build_response()
      %{status_code: status_code} -> build_error_response(status_code)
     end
  end

  defp execute_request(params) do
    HTTPoison.get!(full_url(), [], params: params)
  end

  defp decode_response(response), do: response |> Poison.decode!()
  defp build_error_response(status_code), do: {:error, Status.reason_atom(status_code)}
  defp build_response(%{"error_message" => message} = body), do: {:error, message, body["status"]}
  defp build_response(%{"status" => "OK"} = body), do: {:ok, body}

  defp build_coordinates(%{latitude: latitude, longitude: longitude}), do: "#{latitude},#{longitude}"
  defp full_url, do: @base_url <> @route_url
end
