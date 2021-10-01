defmodule Ruptus3000.Driver.GetDeliveryPathTest do
  use ExUnit.Case, async: true
  alias Ruptus3000.Driver.GetDeliveryPath

  @data %{
    "collect_point" => %{
      "localization" => %{
        "latitude" => 33.8098177,
        "longitude" => -117.9154353
      }
    },
    "delivery_point" => %{
      "localization" => %{
        "latitude" => 34.1330949,
        "longitude" => -118.3524442
      }
    }
  }

  setup_all do
    [result: GetDeliveryPath.handle(@data)]
  end

  test "It handles successfully", %{result: result} do
    assert {:ok, @data, _} = result
  end

  test "It returns a map with to_delivery_point key and map, with distance, duration and a polyline", %{result: result} do
    {_, _, result_info} = result
    assert %{to_delivery_point: %{ distance: _, duration: _, polyline: _}} = result_info
  end

  test "It returns the correct distance and duration", %{result: result} do
    {_, _, result_info} = result
    assert result_info.to_delivery_point.distance == 57836
    assert result_info.to_delivery_point.duration == 2931
  end

  test "It returns the correct polyline", %{result: result} do
    {_, _, result_info} = result
    assert result_info.to_delivery_point.polyline == "knjmEnjunUzO?p@??g@_@BcD@cD@{E@eHEqN?{J@y@D]M]_@MeA`@s@n@M^PVl@Aj@Q\\cAnAOVuA|Ay@pA{EhFmBlBmO`PyJxJ_HrFkIbGmI~HaJvJuOvPk@h@aDnF_B~D{@|Cu@jDeAjHoBbNsAnFcBrEu]rw@_MnXqHrMqB~DeClGgNj]iKhWsK~VcFhJcE`GoGvIaDxEu@~A{AzEg@|Bq@lDqBbIuCzMiDlJqBpEeFlJaE`HmG~MqVzj@}I~RiFjLaDpGgDzEuF~FuIrLw@nAy@vAmEnJ}BvGsFbPeN|[q@|A}HhQgJpQkFhMoCdFiBnEuGdPuJdVsF|MaDpHcH~NeMxVuFxKsOx]wFzLsE|HyGrJeEzEoGrG{QvQ{ClDwAlBuDxGuFtLcExHuHnKsGxGcH`FwHzE_EfCcd@zXwQxKo@l@_CtA_KxGwHzEmIxF{XjPat@bb@{J|FwGbEkDzCeCrCwDxFeN`Tcd@hr@cDzEiDnDqCpBoDlBcBn@wJ|BqIdB_JjBqFpAqFxBgGrDeNrJ{NpNuRtRaIrIkIfNiErEsBpBc[fZ_VvTkDtBqDhBuAx@iCrBwM|L_FlEiEjEcInJwDrEmAlBkBhDoBvDyAtBaCdCkHrGiDdE{AnCwDfKeGfQeClHeAtEkB`Jy@tBuBhEy@dBm@|AaPze@[pAiA`Ia@jIBr[AjVq@rI_AlFmAjEuItW{Lp^iAlEU|@Ct@qArFwD~KmIhVsExMuDfJmC~E}BzCmCpCiCvBqDrBkEbA}BNuA?cD]cDOaDLsCJ_BEwFs@eJs@kPNkDZuDl@mEpAsEnBkDtAgElBo@f@oAbBkAhDSjCs@zH{AxP}@|La@bHQpEDpC@hEWzBsAhEaGzK{HzNgEjH{F~HoG`GyNrL_EnFyEfHqFpI{DhIoAzD{CpLmHxYgHvTeI~VeErKsCbKeIfb@_Fd]qB~PcA~FgAlEoC`H_CjF_LnZcDrH{H~MkKnPeDpDgDjCyNvHyBjA_C`BgCrCoApBoIvOaFjHuFtEsT~KwDpBmBzAmBtBwBzDgBvGa@pDKlFGnGg@vEYtAwAfEeFxJwIbQ{FdLsCnEkApAqCvBiDxAsD~@uM|CuGnAoDl@kDbAaH~CcFjDeE~DY`@_@Ti@b@oEbFcHfIaBnA{C~AqDlBkDpDyC|C[^OPNJd@^`@p@@HU`@Yn@CVyAxB{@zAy@rA{B`EgDbGo@hA{@fAg@`AO`@[Ka@MeASw@W"
  end
end
