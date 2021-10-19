
defmodule Ruptus3000Web.ReportsLive.Index do
  use Ruptus3000Web, :live_view

  alias Ruptus3000Web.Live.Credentials
  alias Ruptus3000.Delivery
  alias Phoenix.PubSub

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

  def handle_event("select_report", report, socket) do
    IO.inspect(socket)
    {:noreply, socket}
  end

  # defp get_user_boards(user) do
  #   Table.participant_board(Table.find_participants_where(user_id: user.id))
  # end

  # def handle_event("delete_board", board, socket) do
  #   user = BeaverBoard.Users.get!(socket.assigns.current_user.id)

  #   board_id = Map.get(board, "id") |> String.to_integer()

  #   BeaverBoard.Table.delete_board(BeaverBoard.Table.get_board!(board_id) |> IO.inspect)
  #   {:noreply, assign(socket, boards: get_user_boards(user))}
  # end
  defp topic(user_id), do: "reports:#{user_id}"
end
