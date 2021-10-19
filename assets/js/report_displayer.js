export const ReportDisplayer = {
  mounted() {
    const hook = this;
    const selector = "#" + this.el.id;
    const element = this.el;
    console.log(this.el, this.el.id);

    this.handleEvent("display-report", evt => {
      console.log(evt, "FUI DISPATCHADO")
    })
  }
}
