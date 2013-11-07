<div id="dashboard">
<h3>Ustawienia sensorów temperatury NEW:</h3>
	<table>

	{foreach from=$sensors key=key item=sensor}
	<tr>
	    <td><input class="long" name="sensors[{$sensor.sensor_id}][sensor_name]" value="{$sensor.sensor_name}"></td>
	    <td>
		<select name="sensors[{$sensor.sensor_id}][sensor_address]" id="sensors[{$sensor.sensor_id}]sensor_address">
			<option value="none">Brak</option>
			{foreach from=$temp_sensors item="sensor_id"}
			<option{if $sensor_id == $sensor.sensor_address} selected="selected"{/if}>{$sensor.sensor_address}</option>
			{/foreach}
		</select>
	        korekta: <input class="temp_select" type="text" id="sensors[{$sensor.sensor_id}][sensor_corr]" name="sensors[{$sensor.sensor_id}][sensor_corr]" value ="{$sensor.sensor_corr}">
	    </td>
	</tr>
	{/foreach}

	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	
</div>	
