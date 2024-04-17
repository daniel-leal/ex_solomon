import "phoenix_html";
import Alpine from "alpinejs";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import "flowbite/dist/flowbite.phoenix.js";

import Datepicker from "flowbite-datepicker/Datepicker";
import DateRangePicker from "flowbite-datepicker/DateRangePicker";
import DatepickerLocalePT from "flowbite-datepicker/locales/pt-BR";
import ApexCharts from "apexcharts";

import darkModeHook from "../vendor/dark_mode";

Alpine.start();
window.Alpine = Alpine;

let Hooks = {};

Hooks.InitAlpine = {
  updated() {
    this.__x = new Alpine();
    this.__x.init();
  },
};

Hooks.DarkThemeToggle = darkModeHook;

Object.assign(Datepicker.locales, DatepickerLocalePT);
Hooks.DateRangePicker = {
  mounted() {
    const datepickerEl = this.el;
    new DateRangePicker(datepickerEl, {
      format: "dd/mm/yyyy",
      language: "pt-BR",
      todayBtn: true,
      todayBtnMode: 1,
    });
  },
  updated() {
    this.mounted();
  },
};

Hooks.BarChart = {
  mounted() {
    const seriesData = JSON.parse(this.el.dataset.series);
    const categoriesData = JSON.parse(this.el.dataset.categories);

    const options = {
      series: seriesData,
      chart: {
        type: "bar",
        height: 400,
        toolbar: {
          show: false,
        },
      },
      plotOptions: {
        bar: {
          sparkline: { enabled: false },
          horizontal: false,
          columnWidth: "85%",
          endingShape: "rounded",
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        show: true,
        width: 2,
        colors: ["transparent"],
      },
      xaxis: {
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
          },
          formatter: function (value) {
            return value;
          },
        },
        categories: categoriesData,
      },
      yaxis: {
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
          },
          formatter: function (value) {
            return value;
          },
        },
      },
      fill: {
        opacity: 1,
      },
      tooltip: {
        y: {
          formatter: function (val) {
            return "R$ " + val;
          },
        },
      },
      legend: {
        show: true,
        position: "bottom",
      },
    };

    const chart = new ApexCharts(this.el, options);
    chart.render();
  },
};

Hooks.DonutChart = {
  mounted() {
    const seriesData = JSON.parse(this.el.dataset.series);
    const categoriesData = JSON.parse(this.el.dataset.categories);

    const getChartOptions = () => {
      return {
        series: seriesData,
        colors: [
          "#E74694",
          "#FACC15",
          "#16BDCA",
          "#818CF8",
          "#FCA5A5",
          "#1C64F2",
          "#FDBA8C",
          "#D946EF",
          "#14B8A6",
        ],
        chart: {
          height: 400,
          width: "100%",
          type: "donut",
        },
        stroke: {
          colors: ["transparent"],
          lineCap: "",
        },
        plotOptions: {
          pie: {
            donut: {
              labels: {
                show: true,
                name: {
                  show: true,
                  fontFamily: "Inter, sans-serif",
                  offsetY: 20,
                },
                total: {
                  showAlways: true,
                  show: true,
                  label: "Despesas Totais",
                  fontFamily: "Inter, sans-serif",
                  formatter: function (w) {
                    const sum = w.globals.seriesTotals.reduce((a, b) => {
                      return a + b;
                    }, 0);
                    return "R$ " + sum;
                  },
                },
                value: {
                  show: true,
                  fontFamily: "Inter, sans-serif",
                  offsetY: -20,
                  formatter: function (value) {
                    return "R$ " + value;
                  },
                },
              },
              size: "80%",
            },
          },
        },
        grid: {
          padding: {
            top: -2,
          },
        },
        labels: categoriesData,
        dataLabels: {
          enabled: true,
        },
        legend: {
          position: "bottom",
          fontFamily: "Inter, sans-serif",
        },
        yaxis: {
          labels: {
            formatter: function (value) {
              return "R$ " + value;
            },
          },
        },
        xaxis: {
          labels: {
            formatter: function (value) {
              return "R$ " + value;
            },
          },
          axisTicks: {
            show: false,
          },
          axisBorder: {
            show: false,
          },
        },
      };
    };

    const chart = new ApexCharts(this.el, getChartOptions());
    chart.render();
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
