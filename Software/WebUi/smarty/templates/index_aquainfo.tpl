<div id="{if $daemon_data->daemon->pid == null}dashboard_red{else}dashboard{/if}">
    <table>
	<tr>
	    <td>
	        <img src ="img/welcome_logo.png" style="float:left;"><BR>
	    </td>
	</tr>
	<tr>
	
	<h3>Informacje o sterowniku:</h3>
	<div style="float:right;font-size:600%">
	{foreach from=$status.aquapi.devices.device item="device"}
	    {if $device.type == 1 && $device.id == $masterinterfaceid}
		{$device.measured_value|string_format:"%.1f"} {if isset($interfaceunits.{$device.id}.unit_name)}{$interfaceunits.{$device.id}.unit_name}{/if}
	    {/if}
	{/foreach}

	</div>
	</tr>
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
	<tr>
	    <td>PID demona:</td><td>{if $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->pid}{/if}</td>
	</tr>
	<tr>
	    <td>Kompilacja demona:</td><td>{if  $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->compilation_date}{/if}</td>
	</tr>
    </table>
</div>