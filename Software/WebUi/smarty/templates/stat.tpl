{include "header.tpl"}

{literal}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
		google.load("visualization", "1", {packages:["corechart"], 'language': 'pl'});
{/literal}
		google.setOnLoadCallback(drawChart);

		function drawChart() {
			var TempTable = new google.visualization.DataTable();	  
			TempTable.addColumn('datetime', 'Czas');
			TempTable.addColumn('number', 'TZ');	  
			TempTable.addColumn('number', 'TG');	  
			TempTable.addColumn('number', 'TP1');	  
			TempTable.addColumn('number', 'TP2');	  
			TempTable.addColumn('number', 'TP3');	  
			TempTable.addRows([
			{foreach from=$stat key="key" item="entry" name="stats"}
				[new Date({$key|date_format:"%Y, "}{math equation="x-1" x=$key|date_format:"%m"}{$key|date_format:", %e, %H, %M"}),{if $entry.0==null}null{else}{$entry.0}{/if},{if $entry.1==null}null{else}{$entry.1}{/if},{if $entry.2==null}null{else}{$entry.2}{/if},{if $entry.3==null}null{else}{$entry.3}{/if},{if $entry.4==null}null{else}{$entry.4}{/if}]{if !$smarty.foreach.stats.last},{/if}
				
			{/foreach}
			]);
		
{foreach from=$outputs_names key="key" item="entry"}
			var LogicTable{$entry.id} = new google.visualization.DataTable();	  
			LogicTable{$entry.id}.addColumn('datetime', 'Czas');
			LogicTable{$entry.id}.addColumn('number', '{$key}');	  
			LogicTable{$entry.id}.addRows([
			{foreach from=$outputs_arr key="key" item="item" name="stats"}
			<!-- {$item.{$entry.id}} -->
				{if isset($item.{$entry.id})}[new Date({$key|date_format:"%Y, "}{math equation="x-1" x=$key|date_format:"%m"}{$key|date_format:", %e, %H, %M"}),{$item.{$entry.id}}]{if !$smarty.foreach.stats.last},{/if}{/if}
				
			{/foreach}
			]);
{/foreach}
{literal}		
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
			'title': 'Przebieg stanów',
            //'chartArea': {'width': '90%', 'height': '80%'},
            'chartArea': {'left': 60, 'top':30, 'height': '200', 'width': '99%'},
            'legend': {'position': 'bottom'},
			'vAxis': {'title': 'Stan'},
			'hAxis': {'title': 'Czas'}
		};
{/literal}
		
		var dataView = new google.visualization.DataView(TempTable);
        var chart = new google.visualization.LineChart(document.getElementById('chart_temp'));
        chart.draw(dataView, options1);

{foreach from=$outputs_names key="key" item="entry"}
		var dataView = new google.visualization.DataView(LogicTable{$entry.id});
        var chart = new google.visualization.AreaChart(document.getElementById('chart_logic{$entry.id}'));
        chart.draw(dataView, options2);		
{/foreach}
	}
</script>

<a href="/stat.php">Dzień</a>
<a href="/stat.php?limit=week">Tydzień</a>
<a href="/stat.php?limit=month">Miesiąc</a>
<a href="/stat.php?limit=no_limit">Bez limitu</a>

<div id="chart_temp" style="width: 98%; height: 400px;"></div>

{foreach from=$outputs_names key="key" item="entry"}
<div id="chart_logic{$entry.id}" style="width: 98%; height: 100px;"></div>
{/foreach}
{*
<table style="float:right">
<tr><th>Czas</th><th>0</th><th>1</th><th>2</th><th>3</th></tr>

{foreach from=$outputs_arr key="key" item="entry"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$key|date_format:"%d-%m %H:%M"}</td>        
		<td>{$entry.0}</td>
		<td>{$entry.1}</td>
		<td>{$entry.2}</td>
		<td>{$entry.3}</td>
    </tr>
{/foreach}
</table>
*}

{include "footer.tpl"}