{include "header.tpl"}

<!-- <script src="js/Chart.bundle.js"></script> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<div class="chart-container" style="position: relative; height:300; width:98%">
    <canvas id="myChart"></canvas>
</div>

<script>
var ctx = document.getElementById("myChart");
var scatterChart = new Chart(ctx, {
    type: 'scatter',
    data: {
        datasets: [
		
{foreach from=$interfaces item="entry"}
	{
		label: '{$entry.interface_name}',
		data: [
		{foreach from=$entry.interface_stat item="stat"}
		{ x: new Date({$stat.stat_date|date_format:"%Y"},{$stat.stat_date|date_format:"%m"},{$stat.stat_date|date_format:"%d"},{$stat.stat_date|date_format:"%H"},{$stat.stat_date|date_format:"%M"},{$stat.stat_date|date_format:"%S"}) , y: {$stat.stat_value} },
		{/foreach}
		], steppedLine: true},
{/foreach}		
		
		
]
    },
options: {
	
		}
});
</script>
<!--
<a href="stat.php">Dzień</a>
<a href="stat.php?limit=week">Tydzień</a>
<a href="stat.php?limit=month">Miesiąc</a>
<a href="stat.php?limit=no_limit">Bez limitu</a>
-->
{include "footer.tpl"}