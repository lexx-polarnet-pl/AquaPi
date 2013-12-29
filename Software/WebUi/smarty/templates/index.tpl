{include "header.tpl"}

<div id="dashboard">
    <h3>Wyjścia & sensory:</h3>
	<table style="width:100%">
	<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Typ</th><th>Stan</th></tr>
	{foreach from=$daemon_data->devices->device item="device"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device->name} ({$device->address})</td>
		<td>{$device->type}</td>
		<td>
			{if $device.interface_icon}
				    <img src="img/{$device.interface_icon}">
			{else}
				    <img src="img/device.png">
			{/if}
		
		<img src="img/{if $device->state == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px"></td>
    </tr>
	{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="3">Brak komunikacji z demonem</td>
		</tr>	
	{/foreach}	
	</table>
</div>

<div id="{if $daemon_data->daemon->pid == null}dashboard_red{else}dashboard{/if}">
<img src ="img/welcome_logo.png" style="float:left;">
<h3>Informacje o sterowniku:</h3>
<table>
<tr><td>Czas</td><td>{$time}</td></tr>
<tr><td>Temperatura zbiornika:</td><td>{$sensor_master_temp|string_format:"%.2f"}&deg;C</td></tr>
<tr><td>Uruchomiony:</td><td>{$enabled}</td></tr>
<tr><td>Wersja jądra:</td><td>{$uname_r}</td></tr>
<tr><td>Kompilacja:</td><td>{$uname_v}</td></tr>
<tr><td>Obciążenie:</td><td>{$load.0}, {$load.1}, {$load.2}</td></tr>
<tr><td>Temperatura CPU:</td><td>{$cputemp|string_format:"%.2f"}&deg;C</td></tr>
<tr><td>Wersja AquaPi/DB:</td><td>{$aquapi_ver}/{$CONFIG.db_version}</td></tr>
<tr><td>Ostatnia aktywność daemona:</td><td>
{if $CONFIG.demon_last_activity lt $smarty.now-$CONFIG.max_daemon_inactivity}<B><U>{/if}
{$smarty.now-$CONFIG.demon_last_activity} sek temu ({$CONFIG.demon_last_activity|date_format:"%e.%m.%Y&nbsp;%H:%M:%S"})
{if $CONFIG.demon_last_activity lt $smarty.now-$CONFIG.max_daemon_inactivity}</B></U>{/if}
</td></tr>
<tr><td>PID demona:</td><td>{if  $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->pid}{/if}</td></tr>
<tr><td>Kompilacja demona:</td><td>{if  $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->compilation_date}{/if}</td></tr>
</table>
</div>

<div id="dashboard">
<h3>Komunikaty informacyjne z ostatnich 48h:</h3>
{include "index_logtable.tpl" logs = $last5infologs}
</div>
</div>

<div id="dashboard">
<h3>Komunikaty błędów z ostatnich 48h:</h3>
{include "index_logtable.tpl" logs = $last5warnlogs}
</div>

{include "footer.tpl"}