defmodule Ruptus3000Web.ReportsLive.Index do
  use Ruptus3000Web, :live_view

  alias Ruptus3000Web.ReportsLive.Helpers
  alias Ruptus3000Web.Live.Credentials
  alias Ruptus3000.Delivery.Report
  alias Ruptus3000.Delivery
  alias Phoenix.PubSub
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(_params, session, socket) do
    with {:ok, user} <- Credentials.get_user(socket, session) do
      PubSub.subscribe(Ruptus3000.PubSub, topic(user.id))
      reports = Delivery.get_user_reports(user.id)
      {:ok, assign(socket, current_user: user, reports: reports, selected_report: nil)}
    else
      _any -> {:ok, redirect(socket, to: "/")}
    end
  end

  def handle_event("select_report", %{"report_id" => report_id}, socket) do
    with %Report{} = report <- Delivery.get_report(report_id),
      true <- Delivery.authorize_report(report, socket.assigns.current_user) do
        {:noreply, assign(socket, selected_report: report) |> push_event("display-report", %{report: Delivery.exhibit_report(report)})}
      else
        _any -> {:noreply, socket}
      end
  end

  def handle_info(%Broadcast{event: "update_reports"}, socket) do
    reports = Delivery.get_user_reports(socket.assigns.current_user.id)
    {:noreply, socket |> assign(reports: reports)}
  end

  defp topic(user_id), do: "reports:#{user_id}"
end
