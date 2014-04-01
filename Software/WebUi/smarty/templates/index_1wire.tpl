<div id="dashboard">
    <h3>Sensory</h3>
    <table style="width:100%">
	<tr bgcolor="#aaaaaa"><th>Nazwa</th><th>Wartość</th></tr>
	{foreach from=$status.aquapi.devices.device item="device"}
	    {if $device.type == 1}	
		<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			<td>
				{if isset($icons[{$device.id}])}
						<img src="img/{$icons[{$device.id}]}">
				{else}
						<img src="img/sensor.png">
				{/if}
				{$device.name}
			</td>
			<td>
				{$device.measured_value|string_format:"%.1f"} {if isset($interfaceunits.{$device.id}.unit_name)}{$interfaceunits.{$device.id}.unit_name}{/if}
			</td>
		</tr>
	    {/if}
	{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="4">Brak komunikacji z demonem</td>
		</tr>	
	{/foreach}	
	</table>
</div>