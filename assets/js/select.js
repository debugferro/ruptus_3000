import { addPolyline } from './map'

export const SelectReport = {
  mounted() {
    const hook = this;
    const selector = "#" + this.el.id;
    const element = this.el;
    // console.log(this.el, this.el.id);

    element.addEventListener("click", evt => {
      hook.pushEventTo(selector, "select_report", {
        report: element.getAttribute("report-id")
      })
      polyline = document.getElementById(`info-${element.getAttribute("report-id")}`).getAttribute("full-polyline")
      addPolyline(polyline)
    })

  }
}
