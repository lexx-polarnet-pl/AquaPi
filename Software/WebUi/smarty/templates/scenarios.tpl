{include "header.tpl"}

{foreach from=$scenarios item="scenario"}
	<a href ="scenarios.php?id={$scenario.scenario_id}">
	<div id ='scenario_{$scenario.scenario_id}' class='modern_box b1x1' style='background-color: rgb(200,200,0); background-image: url(img/icons/{$scenario.interface_icon});'>
	{$scenario.scenario_name}
	</div>
	</a>
{/foreach}	
	<a href ="scenarios.php?id=new">
	<div id ='scenario_new' class='modern_box b1x1' style='background-color: rgb(200,200,0); background-image: url(img/icons/appbar.clock.png);'>
	Dodaj nowy
	</div>
	</a>	
{include "footer.tpl"}