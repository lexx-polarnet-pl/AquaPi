{include "header.tpl"}

{literal}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
		google.load("visualization", "1", {packages:["corechart"], 'language': 'pl'});

		google.setOnLoadCallback(drawChart);

		function drawChart() {
			var TempTable = new google.visualization.DataTable();	  
			TempTable.addColumn('datetime', 'Czas');
			TempTable.addColumn('number', 'Temperatura zadana');	  
			TempTable.addColumn('number', 'Temperatura wody');	  
			TempTable.addRows([
			{/literal}{foreach from=$stat item="entry" name="stats"}
				[new Date({$entry.time_st|date_format:"%Y, "}{math equation="x-1" x=$entry.time_st|date_format:"%m"}{$entry.time_st|date_format:", %e, %H, %M"}),{$entry.temp_t},{$entry.temp_a}]{if !$smarty.foreach.stats.last},{/if}
			{/foreach}{literal}
			]);

			var LogicTable = new google.visualization.DataTable();	  
			LogicTable.addColumn('datetime', 'Czas');
			LogicTable.addColumn('number', 'Dzień');	  
			LogicTable.addColumn('number', 'Grzanie');	  
			LogicTable.addRows([
			{/literal}{foreach from=$stat item="entry" name="stats"}
				[new Date({$entry.time_st|date_format:"%Y, "}{math equation="x-1" x=$entry.time_st|date_format:"%m"}{$entry.time_st|date_format:", %e, %H, %M"}),{$entry.day},{$entry.heat}]{if !$smarty.foreach.stats.last},{/if}
			{/foreach}{literal}
			]);
			
		var options1 = {
			//'pointSize': 5,
			'title': 'Przebieg temperatury',
            'chartArea': {'left': 60, 'top':30, 'height': '300', 'width': '99%'},
            'legend': {'position': 'bottom'},
			'vAxis': {'title': 'Temperatura'},
			'hAxis': {'title': 'Czas'}
		};

		var options2 = {
			//'pointSize': 5,
			'title': 'Przebiegi stanów wyjściowych',
            //'chartArea': {'width': '90%', 'height': '80%'},
            'chartArea': {'left': 60, 'top':30, 'height': '200', 'width': '99%'},
            'legend': {'position': 'bottom'},
			'vAxis': {'title': 'Stan wyjścia'},
			'hAxis': {'title': 'Czas'}
		};
		
		var dataView = new google.visualization.DataView(TempTable);
        var chart = new google.visualization.LineChart(document.getElementById('chart_temp'));
        chart.draw(dataView, options1);

		var dataView = new google.visualization.DataView(LogicTable);
        var chart = new google.visualization.AreaChart(document.getElementById('chart_logic'));
        chart.draw(dataView, options2);

	}
</script>
{/literal}
<a href="/stat.php">Dzień</a>
<a href="/stat.php?limit=week">Tydzień</a>
<a href="/stat.php?limit=month">Miesiąc</a>
<a href="/stat.php?limit=no_limit">Bez limitu</a>

<div id="chart_temp" style="width: 98%; height: 400px;"></div>

<div id="chart_logic" style="width: 98%; height: 300px;"></div>

{*
<table style="float:right">
<tr><th>Czas</th><th>Dz</th><th>Tz</th><th>G</th><th>Tact</th></tr>

{foreach from=$stat item="entry"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$entry.time_st|date_format:"%H:%M"}</td>        
		<td>{if $entry.day}<img src="/img/day_s.png">{else}<img src="/img/night_s.png">{/if}</td>
		<td>{$entry.temp_t}</td>
		<td>{if $entry.heat}<img src="/img/heater_on.png" title="Grzałka włączona">{else}<img src="/img/heater_off.png" title="Grzałka wyłączona">{/if}</td>
		<td>{$entry.temp_a}</td>
    </tr>
{/foreach}
</table>
*}

{include "footer.tpl"}