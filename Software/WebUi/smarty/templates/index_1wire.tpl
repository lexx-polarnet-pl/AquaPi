<table style="width:100%">
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
</table>
