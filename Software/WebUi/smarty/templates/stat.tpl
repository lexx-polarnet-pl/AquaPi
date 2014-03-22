{include "header.tpl"}


<script src="js/highstock.js"></script>
<script src="js/modules/exporting.js"></script>
{literal}
<script>
$(function() {
	var seriesOptions = [],
	yAxisOptions 	= [],
	seriesCounter 	= 0;
	
	{/literal}
	interfaces	= [
			{foreach from=$sensors.temps item=sensor}[{$sensor.interface_id},"{$sensor.interface_name}", 0, 'spline'], {/foreach}
			{foreach from=$sensors.ports item=sensor}[{$sensor.interface_id},"{$sensor.interface_name}", 1, ''], {/foreach}
			
	];
	{literal}
	colors 		= Highcharts.getOptions().colors;

	$.each(interfaces, function(i, name)
	{
		$.getJSON('jsonp.php?interfaceid='+ name[0] +'{/literal}&limit={$limit}&simplify_graphs={$simplify_graphs}&callback{literal}=?',
		function(data) {
			seriesOptions[i] = {
				name:	name[1],
				id:	name[0],
				type:	name[3],
				yAxis: 	name[2],
				data:	data
			};
			seriesCounter++;
			
			if (seriesCounter == interfaces.length)
			{
				createChart();
			}
		});
	});

	
	function createChart(container)
	{
		$('#container').highcharts('StockChart', {
				chart: {
			},
			
			rangeSelector: {
				inputEnabled: $('#container').width() > 480,
				selected: 1
			},
			
			title: {
				text: 'Czujniki 1-wire'
			},
			yAxis : [{
				title : {
					text : 'Temperatura [°C]'
				},
				height: 300,
				lineWidth: 2
			},
				{
				title: {
					text: 'Stan'
				},
				top: 400,
				height: 100,
				offset: 0,
				lineWidth: 2
			}],
			xAxis: {
				type: "datetime",
				ordinal: false,
			},
			legend: {
				enabled: true,
			},
			tooltip: {
				valueDecimals: 1,
				valueSuffix: '°C',
				crosshairs: [true,true]
		        },
			plotOptions: {
				line: {
					//connectNulls: false,
					//gapSize: 1
				}
			},
			rangeSelector: {
				buttons: [
				{
					type: 'day',
					count: 1,
					text: '1d'
				},
				{
					type: 'day',
					count: 3,
					text: '3d'
				},
				{
					type: 'week',
					count: 1,
					text: '1w'
				},
				{
					type: 'week',
					count: 2,
					text: '2w'
				},
				{
					type: 'month',
					count: 1,
					text: '1m'
				},
				{
					type: 'month',
					count: 3,
					text: '3m'
				},
				{
					type: 'month',
					count: 6,
					text: '6m'
				},
				{
					type: 'year',
					count: 1,
					text: '1y'
				},
				{
					type: 'all',
					text: 'All'
				}]
			},
			series: seriesOptions
		});
	}

});



</script>



{/literal}
<div id="container" style="height: 650px; min-width: 350px"></div>
Zmień okres pobieranych danych na 
<a href="stat.php?limit=month">1 miesiąc, </a>
<a href="stat.php?limit=year">rok, </a>
<a href="stat.php?limit=no_limit">bez limitu</a>


{include "footer.tpl"}