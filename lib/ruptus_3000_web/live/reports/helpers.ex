defmodule Ruptus3000Web.ReportsLive.Helpers do
  use Phoenix.HTML
  alias Ruptus3000.Delivery.Report
  alias Ruptus3000.Delivery.Driver
  alias Ruptus3000.Delivery.RejectedDriver
  def get_report_driver_name(%Report{} = report), do: Map.get(report, :driver) |> get_driver_name()
  def get_driver_name(%Driver{} = driver), do: Map.get(driver, :full_name)
  def get_rejected_driver_name(%RejectedDriver{} = rejected_driver), do: Map.get(rejected_driver, :driver) |> get_driver_name()
  def get_estimated_time(%Report{} = report) do
    Map.get(report, :to_collect_duration) + Map.get(report, :to_deliver_duration)
    |> Timex.Duration.from_minutes()
    |> Timex.lformat_duration("pt", :humanized)
  end
  def get_total_distance(%Report{} = report) do
    Map.get(report, :to_collect_distance) + Map.get(report, :to_deliver_distance)
  end
  def parse_time(time) do
    {:ok, parsed_time} = Timex.format(time, "%d/%m/%y às %H:%M:%S", :strftime)
    parsed_time
  end

  def check_selection(nil, report), do: ""
  def check_selection(selected_report, report) do
    if selected_report |> Map.get(:id) == report |> Map.get(:id) do
      "report-selected"
    else
      ""
    end
  end
end
