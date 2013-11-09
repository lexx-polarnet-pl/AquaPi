<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czujniki temperatury</th><th>Wartość</th></tr>
    {foreach from=$temperatures key=key item=sensor}

    <tr bgcolor="#cccccc">
		<td>{$sensor.sensor_name}</td>     
		<td>{if $sensor.sensor_temp==''}--.--{else}{$sensor.sensor_temp|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    {/foreach}
</table>
