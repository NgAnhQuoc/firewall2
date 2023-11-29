import ApexCharts from 'apexcharts'
import {
	format
} from "date-fns";

const GraphData = {
	init() {
		var options = {
			series: [{
				name: 'Traffic',
				type: 'column',
				data: [440, 505, 414, 671, 227, 413, 201, 352, 752, 320, 257, 160]
			}, {
				name: 'Network',
				type: 'line',
				data: [23, 42, 35, 27, 43, 22, 17, 31, 22, 22, 12, 16]
			}],
			chart: {
				height: 350,
				type: 'line',
			},
			stroke: {
				width: [0, 4]
			},
			title: {
				text: 'Traffic Sources'
			},
			dataLabels: {
				enabled: true,
				enabledOnSeries: [1]
			},
			labels: ['01 Jan 2001', '02 Jan 2001', '03 Jan 2001', '04 Jan 2001', '05 Jan 2001', '06 Jan 2001', '07 Jan 2001', '08 Jan 2001', '09 Jan 2001', '10 Jan 2001', '11 Jan 2001', '12 Jan 2001'],
			xaxis: {
				type: 'datetime'
			},
			yaxis: [{
				title: {
					text: 'Traffic',
				},

			}, {
				opposite: true,
				title: {
					text: 'Network'
				}
			}]
		};

		var chart = new ApexCharts(document.querySelector("#fwchart"), options);
		chart.render();
	},

	update_chart_data(data) {
		var options = {
			title: {
				text: ' Hits '
			},
			dataLabels: {
				enabled: true,
				enabledOnSeries: [1]
			},
			series: [],
			chart: {
				id: 'area-datetime',
				type: 'area',
				height: 500,
				zoom: {
					enabled: true
				}
			},
			dataLabels: {
				enabled: false
			},
			labels: '',
			markers: {
				size: 0,
				style: 'hollow',
			},
			xaxis: {
				type: 'category',
				categories: '',
				tickAmount: false,
				labels: {
					show: true,
					format: 'dd/MM/yyyy',
					datetimeUTC: false
				}
			},
			tooltip: {
				x: {
					format: 'dd/MM/yyyy H:m'
				}
			},
			fill: {
				type: 'gradient',
				gradient: {
					shadeIntensity: 1,
					opacityFrom: 0.7,
					opacityTo: 0.9,
					stops: [0, 100]
				}
			}
		};

		var chart = new ApexCharts(document.querySelector("#fwchart"), options);
		chart.render();

		var items = [];
		var xlabel = [];
		for (var i in data.items) {
			items.push(data.items[i].doc_count);
			xlabel.push(format(new Date(data.items[i].key_as_string), "yyyy-MM-dd H:mm"));
		}

		chart.updateOptions({
			title: {
				text: data.total + ' Hits '
			},
			xaxis: {
				categories: xlabel
			},
			series: [{
				data: items,
				name: 'Hits'
			}],

		});
	}
}
export default GraphData;
