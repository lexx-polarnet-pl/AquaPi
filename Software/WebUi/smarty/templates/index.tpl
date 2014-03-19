{include "header.tpl"}

<div id="dashboard">
    <h3>Wyjścia:</h3>
    <div style="float:left;">
        {include "index_outputs.tpl"}
    </div>
</div>

{if $CONFIG.webui.show_data_from_DB eq 1}
<div id="dashboard">
    <h3>Wyjścia & sensory:</h3>
    <div style="width:49%; float:left;">
        {include "index_gpio.tpl"}
    </div>
    <div style="width:49%; float:left;">
        {include "index_1wire.tpl"}
    </div>
</div>
{/if}

<div id="dashboard">
	<h3>Wejścia</h3>
    <table style="width:100%">
	<tr bgcolor="#aaaaaa"><th>Nazwa</th><th>Wartość</th></tr>
	{foreach from=$daemon_data->devices->device item="device"}
		{if $device->type == 1}	
        <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			<td>
				{if $icons[{$device->id}]}
						<img src="img/{$icons[{$device->id}]}">
				{else}
						<img src="img/sensor.png">
				{/if}
				{$device->name}
			</td>
		<td>{$device->measured_value|string_format:"%.1f"}</td>
		{/if}
	</tr>
	{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="4">Brak komunikacji z demonem</td>
		</tr>	
	{/foreach}	
	</table>
</div>

<div id="{if $daemon_data->daemon->pid == null && $CONFIG.daemon.location == 'local'}dashboard_red{else}dashboard{/if}">
    <!-- $CONFIG.demon_last_activity lt $smarty.now-180 -->
    <img src ="img/welcome_logo.png" style="float:left;">
    <h3>Informacje o sterowniku:</h3>
    <table>
	<tr>
	    <td>Czas</td><td>{$time}</td>
	</tr>
	<tr>
	    <td>Uruchomiony:</td><td>{$enabled}</td>
	</tr>
	<tr>
	    <td>Wersja jądra:</td><td>{$sysinfo.aquapi.uname.version}</td>
	</tr>
	<tr>
	    <td>Kompilacja:</td><td>{$sysinfo.aquapi.uname.release}</td>
	</tr>
	<tr>
	    <td>Obciążenie:</td><td>{$sysinfo.aquapi.sysinfo.load.av1m|number_format:2}, {$sysinfo.aquapi.sysinfo.load.av5m|number_format:2}, {$sysinfo.aquapi.sysinfo.load.av15m|number_format:2}</td>
	</tr>
	<tr>
	    <td>Temperatura CPU:</td><td>{$sysinfo.aquapi.system.cputemp|string_format:"%.2f"}&deg;C</td>
	</tr>
	<tr>
	    <td>Wersja AquaPi/DB:</td><td>{$aquapi_ver}/{$CONFIG.db_version}</td>
	</tr>
<!--	<tr>
	    <td>Ostatnia aktywność daemona:</td>
	    <td class="{if $CONFIG.demon_last_activity lt $smarty.now-$CONFIG.max_daemon_inactivity}bold underline{/if}">
		    {$smarty.now-$CONFIG.demon_last_activity} sek temu ({$CONFIG.demon_last_activity|date_format:"%e.%m.%Y&nbsp;%H:%M:%S"})
	    </td>
	</tr>-->
	    <tr>
		<td>PID demona:</td><td>{if $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->pid}{/if}</td>
	    </tr>
	    <tr>
		<td>Kompilacja demona:</td><td>{if  $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->compilation_date}{/if}</td>
	    </tr>
    </table>
</div>

{if $CONFIG.webui.show_data_from_DB eq 1}
<div id="dashboard">
    <h3>Wyjścia & sensory:</h3>
    <div style="width:49%; float:left;">
	{include "index_relayboard.tpl"}
    </div>
    <div style="width:49%; float:left;">
        {include "index_dummy.tpl"}
    </div>
</div>
{/if}

<div id="dashboard">
    <h3>Komunikaty informacyjne z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5infologs}
</div>

<div id="dashboard">
    <h3>Komunikaty błędów z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5warnlogs}
</div>

{include "footer.tpl"}