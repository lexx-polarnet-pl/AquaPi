<div id="dashboard">
<h3>Ustawienia sensorów temperatury:</h3>
	<table>

	{foreach from=$sensors key=key item=sensor}
	<tr>
	    <td>
		<input class="long" name="sensors[{$sensor.sensor_id}][sensor_name]" value="{$sensor.sensor_name}"
				onmouseover="return overlib('Podaj nową nazwę czujnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<select name="sensors[{$sensor.sensor_id}][sensor_address]" id="sensors[{$sensor.sensor_id}][sensor_address]"
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();">
			<option value="none">Brak</option>
			{foreach from=$temp_sensors item="sensor_id"}
			<option{if $sensor_id == $sensor.sensor_address} selected="selected"{/if}>{$sensor_id}</option>
			{/foreach}
		</select>
	        korekta:&nbsp;<input class="temp_select" type="text" id="sensors[{$sensor.sensor_id}][sensor_corr]" name="sensors[{$sensor.sensor_id}][sensor_corr]" value ="{$sensor.sensor_corr}"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
		<td><a href="?action=delete&id={$sensor.sensor_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"><img align="right" src="img/off.png"></a></td>
	    </td>
	</tr>
	{/foreach}
	<tr>
	    <td>
		<input class="long" name="sensors[{$new_sensor_id}][sensor_name]" value=""
				onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<select name="sensors[{$new_sensor_id}][sensor_address]" id="sensors[{$new_sensor_id}][sensor_address]"
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();>
			<option value="none">Brak</option>
			{foreach from=$temp_sensors item="sensor_id"}
			<option>{$sensor_id}</option>
			{/foreach}
		</select>
	        korekta:&nbsp;<input class="temp_select" type="text" id="sensors[{$new_sensor_id}][sensor_corr]"
				name="sensors[{$new_sensor_id}][sensor_corr]" value ="0"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
	    </td>
	    <td></td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	
</div>	
