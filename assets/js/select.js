export const SelectReport = {
  mounted() {
    const hook = this;
    const selector = "#" + this.el.id;
    const element = this.el;

    element.addEventListener("click", evt => {
      const reportId = element.getAttribute("report-id")
      hook.pushEventTo(selector, "select_report", {
        report_id: reportId
      })
    })

  }
}
