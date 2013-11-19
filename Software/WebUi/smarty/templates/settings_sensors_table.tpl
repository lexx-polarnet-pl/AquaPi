<div id="dashboard">
<h3>Ustawienia sensorów temperatury:</h3>
	<table style="width:100%">
	<tr bgcolor="#aaaaaa">
		<th>Przyjazna nazwa</th>
		<th>Czujnik</th>
		<th>Korekta</th>
		<th><img SRC="img/stat_small.png"></th>
		<th>Gł</th>
		<th> </th>
	</tr>
	{foreach from=$sensors key=key item=sensor}
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
	    <td>
		<input class="long" name="sensors[{$sensor.sensor_id}][sensor_name]" value="{$sensor.sensor_name}"
				onmouseover="return overlib('Podaj nową nazwę czujnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<select class="long" name="sensors[{$sensor.sensor_id}][sensor_address]" id="sensors[{$sensor.sensor_id}][sensor_address]"
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();">
			<option value="none">Brak</option>
			{foreach from=$temp_sensors item="sensor_id"}
			<option{if $sensor_id == $sensor.sensor_address} selected="selected"{/if}>{$sensor_id}</option>
			{/foreach}
		</select>
		</td>
		<td>
	        <input class="temp_select" type="text" id="sensors[{$sensor.sensor_id}][sensor_corr]" name="sensors[{$sensor.sensor_id}][sensor_corr]" value ="{$sensor.sensor_corr}"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
	    </td>
	    <td><input type="checkbox" name="sensors[{$sensor.sensor_id}][sensor_draw]" value="1" {if $sensor.sensor_draw eq 1}checked="checked"{/if}
				onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
				onmouseout="return nd();"></td>
	    <td><input type="radio" name="sensors[{$sensor.sensor_id}][sensor_master]" value="1" {if $sensor.sensor_master eq 1}checked="checked"{/if}
				onmouseover="return overlib('Czujnik główny.');"
				onmouseout="return nd();"></td>
	    <td><a href="?action=delete&id={$sensor.sensor_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"><img align="right" src="img/delete_entry.png" title="Skasuj pozycję"></a></td>
	</tr>
	{/foreach}
	<tr bgcolor="#aaaaaa">
	    <td>
		<input class="long" name="sensors[{$new_sensor_id}][sensor_name]" value=""
				onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<select name="sensors[{$new_sensor_id}][sensor_address]" id="sensors[{$new_sensor_id}][sensor_address]"
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();">
			<option value="none">Brak</option>
			{foreach from=$temp_sensors item="sensor_id"}
			<option>{$sensor_id}</option>
			{/foreach}
		</select>
		</td>
	    <td>    
			<input class="temp_select" type="text" id="sensors[{$new_sensor_id}][sensor_corr]"
				name="sensors[{$new_sensor_id}][sensor_corr]" value ="0"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
	    </td>
	    <td><input type="checkbox" name="sensors[{$new_sensor_id}][sensor_draw]" value="1" 
				onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
				onmouseout="return nd();"></td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	
</div>	
