defmodule Ruptus3000.Routing.Report do
  @moduledoc """
    This handler start a task that create reports of this request
  """
  @behaviour Ruptus3000.Routing.Behaviour.Handler
  alias Ruptus3000.Types.Error
  alias Ruptus3000.{Users, Delivery}

  @spec handle({:ok, map(), map()} | Error.basic_tuple() | Error.detailed_tuple()) ::
          {:ok, map()} | Error.basic_tuple() | Error.detailed_tuple()
  def handle({:ok, delivery_data, result} = response) do
    if not Map.get(delivery_data, "force", false) do
      Task.start(fn ->
        report(result, delivery_data)
      end)
    end

    {:ok, result[:result]}
  end

  def handle(error), do: error

  defp report(
         %{
           result: %{
             route: %{
               to_collect_point: collect_point,
               to_delivery_point: delivery_point,
               full_route: full_route
             },
             selected_driver: driver
           }
         } = result,
         delivery_data
       ) do
    user_id = Users.api_credential_where(token: delivery_data["api_key"]) |> Map.get(:user_id)
    %{
      user_id: user_id,
      to_collect_distance: collect_point.distance,
      to_collect_duration: collect_point.duration,
      to_collect_polyline: collect_point.polyline,
      to_collect_localization: [
        collect_point.localization["latitude"],
        collect_point.localization["longitude"]
      ],
      to_deliver_distance: delivery_point.distance,
      to_deliver_duration: delivery_point.duration,
      to_deliver_polyline: delivery_point.polyline,
      to_deliver_localization: [
        delivery_point.localization["latitude"],
        delivery_point.localization["longitude"]
      ],
      full_polyline: full_route.polyline,
      driver_localization: [driver.localization["latitude"], driver.localization["longitude"]],
      driver_id: Delivery.create_or_find_driver(driver) |> Map.get(:id)
    }
    |> Delivery.create_report()
    |> record_rejections(result)
    push_update_event(user_id)
  end

  defp record_rejections({:ok, report}, %{rejected_drivers: rejected_drivers}) do
    Enum.each(rejected_drivers, fn rejected_driver ->
      %{
        driver_id: Delivery.create_or_find_driver(rejected_driver) |> Map.get(:id),
        message: rejected_driver[:error_msg] || "Tempo ou distância relativamente altos",
        error_type: Phoenix.Naming.humanize(rejected_driver[:error_type] || :not_known),
        report_id: report |> Map.get(:id)
      }
      |> Delivery.create_rejected_driver()
    end)
  end

  defp push_update_event(user_id) do
    Ruptus3000Web.Endpoint.broadcast_from(self(), "reports:#{user_id}", "update_reports", %{})
  end
end
