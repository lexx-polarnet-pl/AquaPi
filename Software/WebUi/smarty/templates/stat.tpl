{include "header.tpl"}


<a href="stat.php">Dzień</a>
<a href="stat.php?limit=week">Tydzień</a>
<a href="stat.php?limit=month">Miesiąc</a>
<a href="stat.php?limit=no_limit">Bez limitu</a>

<script src="js/moment.min.js"></script>
<script src="js/Chart.min.js"></script>
<div class="chart-container" style="position: relative;">
    <canvas id="Chart1"></canvas>
</div>
<div class="chart-container" style="position: relative;">
    <canvas id="Chart2"></canvas>
</div>

<script>
var ctx = document.getElementById("Chart1").getContext('2d');
var scatterChart = new Chart(ctx, {
    type: 'scatter',
    data: {
		datasets: [
		
{foreach from=$interfaces item="entry"}{if $entry.interface_type == 1}
	{
		label: '{$entry.interface_name}',
		borderColor: "#{$entry.interface_htmlcolor}",
		backgroundColor: "#{$entry.interface_htmlcolor}",
		fill: false,
		steppedLine: true,
		data: [
		{foreach from=$entry.interface_stat item="stat"}
		{ x: moment("{$stat.stat_date|date_format:"%Y-%m-%d %H:%M:%S"}") , y: {$stat.stat_value} },
		{/foreach}
		]},
{/if}{/foreach}		
		
		
]
    },
options: {
    title: {
        display:true,
        text: 'Wejścia'
    },
	scales: {
            xAxes: [{
				type: 'time',
                time: {
                    unit: 'hour'
                }
            }]
        }
	}
});
</script>
<script>
var ctx = document.getElementById("Chart2").getContext('2d');
var scatterChart = new Chart(ctx, {
    type: 'scatter',
    data: {
		datasets: [
		
{foreach from=$interfaces item="entry"}{if $entry.interface_type == 2 or $entry.interface_type == 3}
	{
		label: '{$entry.interface_name}',
		borderColor: "#{$entry.interface_htmlcolor}",
		backgroundColor: "#{$entry.interface_htmlcolor}",
		fill: false,
		steppedLine: true,
		data: [
		{foreach from=$entry.interface_stat item="stat"}
		{ x: moment("{$stat.stat_date|date_format:"%Y-%m-%d %H:%M:%S"}") , y: {if $entry.interface_type == 3}{$stat.stat_value/100}{else}{$stat.stat_value}{/if} },
		{/foreach}
		]},
{/if}{/foreach}		
		
		
]
    },
options: {
    title: {
        display:true,
        text: 'Wyjścia'
    },
	scales: {
            xAxes: [{
				type: 'time',
                time: {
                    unit: 'hour'
                }
            }]
        }
	}
});
</script>
{include "footer.tpl"}