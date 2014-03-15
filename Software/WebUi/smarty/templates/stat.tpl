{include "header.tpl"}


<script src="js/highstock.js"></script>
<script src="js/modules/exporting.js"></script>
{literal}
<script>
$(function() {
	    var seriesOptions = [],
	    yAxisOptions = [],
	    seriesCounter = 0,
	    names = [{/literal}{foreach from=$sensors item=sensor}[{$sensor.interface_id},"{$sensor.interface_name}"], {/foreach}{literal}],
	    colors = Highcharts.getOptions().colors;

	    $.each(names, function(i, name)
	    {
			$.getJSON('jsonp.php?interfaceid='+ name[0] +'{/literal}&limit={$limit}&simplify_graphs={$simplify_graphs}&callback{literal}=?',
			function(data) {
				    seriesOptions[i] = {
						name:	name[1],
						id:	name[0],
						type:	'spline',
						//datagrouping: { enabled: false},
						data:	data
				    };
			seriesCounter++;
			
			if (seriesCounter == names.length)
			{
				createChart();
			}
		});
	    });

	function createChart() {

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
			yAxis : {
				    title : {
					    text : 'Temperatura [°C]'
				    },
			},
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
			series: seriesOptions
		});
	}

});



</script>



{/literal}
<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>


<a href="stat.php">Dzień</a>
<a href="stat.php?limit=week">Tydzień</a>
<a href="stat.php?limit=month">Miesiąc</a>
<a href="stat.php?limit=no_limit">Bez limitu</a>


{include "footer.tpl"}