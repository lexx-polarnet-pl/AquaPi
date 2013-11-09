<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czujnik temp.</th><th>Wartość</th></tr>
    <tr bgcolor="#cccccc">
		<td>{$temp1.sensor_name}</td>     
		<td>{if $temp1.sensor_temp==''}--.--{else}{$temp1.sensor_temp|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#dddddd">
		<td>{$temp2.sensor_name}</td>     
		<td>{if $temp2.sensor_temp==''}--.--{else}{$temp2.sensor_temp|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#cccccc">
		<td>{$temp3.sensor_name}</td>     
		<td>{if $temp3.sensor_temp==''}--.--{else}{$temp3.sensor_temp|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#dddddd">
		<td>{$temp4.sensor_name}</td>     
		<td>{if $temp4.sensor_temp==''}--.--{else}{$temp4.sensor_temp|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
</table>
