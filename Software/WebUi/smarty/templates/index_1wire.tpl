<!--<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czujniki temperatury</th><th>Wartość</th></tr>
	{foreach from=$interfaces.1wire key=key item=sensor}
	{if $sensor.interface_disabled ne 1}
	<tr bgcolor="#cccccc">
		<td>{$sensor.interface_name}</td>
		<td>
			{if $sensor.interface_temperature eq FALSE}
				?
			{else}
				{$sensor.interface_temperature.stat_value|string_format:"%.2f"}&deg;C
			{/if}
		</td>
	</tr>
	{/if}
	{foreachelse}
	<tr bgcolor="#cccccc">
    		<td colspan="2">Brak danych</td>
	</tr>
	{/foreach}
</table>-->

<div id="dashboard">
    <h3>Sensory</h3>
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
		</tr>
	    {/if}
	{foreachelse}
	    <tr bgcolor="#cccccc">
		<td colspan="4">Brak komunikacji z demonem</td>
	    </tr>	
	{/foreach}	
	</table>
</div>