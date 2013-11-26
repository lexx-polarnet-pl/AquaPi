{include "header.tpl"}


<script src="js/highstock.js"></script>
<script src="js/modules/exporting.js"></script>
{literal}
<script>
    
$(function() {
	    var seriesOptions = [],
			yAxisOptions = [],
			seriesCounter = 0,
			names = [{/literal}{$wire}{literal}],
			colors = Highcharts.getOptions().colors;

	    $.each(names, function(i, name)
	    {
			$.getJSON('jsonp.php?interfaceid='+ name +'{/literal}&limit={$limit}&simplify_graphs={$simplify_graphs}&callback{literal}=?',
			function(data) {
				    seriesOptions[i] = {
						name: name,
						type: 'spline',
						data: data
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
		        selected: 4
		    },

		    yAxis: {
		    	labels: {
		    		formatter: function() {
		    			return (this.value > 0 ? '+' : '') + this.value + '%';
		    		}
		    	},
		    	plotLines: [{
		    		value: 0,
		    		width: 2,
		    		color: 'silver'
		    	}]
		    },
		    
		    plotOptions: {
		    	series: {
		    		compare: 'percent'
		    	}
		    },
		    
		    tooltip: {
		    	pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
		    	valueDecimals: 2
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