import { addRoute } from './map'

export const ReportDisplayer = {
  mounted() {
    const hook = this;
    const selector = "#" + this.el.id;
    const element = this.el;

    this.handleEvent("display-report", evt => {
      addRoute(evt.report)
    });
  }
}
