{include "header.tpl"}

<script>
	$(function() {
		$("#slide_day").slider({
			slide: function(event, ui) { 
					document.getElementById('temp_day').value = ui.value.toFixed(1);
			},
			step: 0.1,
			min: 20,
			max: 30,
			value: {$temp_day|default:25}
		});
		
		$("#slide_night").slider({
			slide: function(event, ui) { 
					document.getElementById('temp_night').value = ui.value.toFixed(1);
			},
			step: 0.1,
			min: 20,
			max: 30,
			value: {$temp_night|default:25}
		});
		
		$("#slide_cool").slider({
			slide: function(event, ui) { 
					document.getElementById('temp_cool').value = ui.value.toFixed(1);
			},
			step: 0.1,
			min: 20,
			max: 30,
			value: {$temp_cool|default:25}
		});
		
		$("#slide_hysteresis").slider({
			slide: function(event, ui) { 
					document.getElementById('hysteresis').value = ui.value.toFixed(1);
			},
			step: 0.1,
			min: 0,
			max: 1,
			value: {$hysteresis|default:1}
		});
		
		$('#day_start').timepicker({
			timeFormat: "hh:mm:ss",
			showSecond: true,
			currentText: "Teraz",
			closeText: "Wybierz",
			timeOnlyTitle: "Wybierz czas",
			timeText: "Czas",
			hourText: "Godzina",
			minuteText: "Minuta",
			secondText: "Sekunda"
		});
		
		$('#day_stop').timepicker({
			timeFormat: "hh:mm:ss",
			showSecond: true,
			currentText: "Teraz",
			closeText: "Wybierz",
			timeOnlyTitle: "Wybierz czas",
			timeText: "Czas",
			hourText: "Godzina",
			minuteText: "Minuta",
			secondText: "Sekunda"
		});		
	});
</script>

<form action="settings.php" method="post">

<div id="dashboard">
<h3>Ustawienia dnia:</h3>
	<table>
	<tr><td>Rozpoczęcie:</td><td><input class="time_select" type="text" name="day_start" id="day_start" value="{$day_start}" /></td></tr>
	<tr><td>Zakończenie:</td><td><input class="time_select" type="text" name="day_stop" id="day_stop" value="{$day_stop}" /></td></tr>
	</table>	
	<INPUT TYPE="image" SRC="/img/submit.png" align="right">
</div>


<div id="dashboard">
<h3>Ustawienia sensorów temperatury:</h3>
	<table>
	<tr><td>Sensor główny:</td><td>
	<select name="temp_sensor" id="temp_sensor" >
		{foreach from=$temp_sensors item="sensor_id"}
		<option{if $sensor_id == $temp_sensor} selected="selected"{/if}>{$sensor_id}</option>
		{/foreach}
	</select>
        korekta: <input class="temp_select" type="text" id="temp_sensor_corr" name="temp_sensor_corr" value ="{$temp_sensor_corr}">
        </td></tr>
	<tr><td>Sensor pomocniczy 1:</td><td>
	<select name="temp_sensor2" id="temp_sensor2" >
		<option value="none">Brak</option>
		{foreach from=$temp_sensors item="sensor_id2"}
		<option{if $sensor_id2 == $temp_sensor2} selected="selected"{/if}>{$sensor_id2}</option>
		{/foreach}
	</select>
        korekta: <input class="temp_select" type="text" id="temp_sensor2_corr" name="temp_sensor2_corr" value ="{$temp_sensor2_corr}">
        </td></tr>
	<tr><td>Sensor pomocniczy 2:</td><td>
	<select name="temp_sensor3" id="temp_sensor3" >
		<option value="none">Brak</option>
		{foreach from=$temp_sensors item="sensor_id3"}
		<option{if $sensor_id3 == $temp_sensor3} selected="selected"{/if}>{$sensor_id3}</option>
		{/foreach}
	</select>
        korekta: <input class="temp_select" type="text" id="temp_sensor3_corr" name="temp_sensor3_corr" value ="{$temp_sensor3_corr}">
        </td></tr>
	<tr><td>Sensor pomocniczy 3:</td><td>
	<select name="temp_sensor4" id="temp_sensor4" >
		<option value="none">Brak</option>
		{foreach from=$temp_sensors item="sensor_id4"}
		<option{if $sensor_id4 == $temp_sensor4} selected="selected"{/if}>{$sensor_id4}</option>
		{/foreach}
	</select>
        korekta: <input class="temp_select" type="text" id="temp_sensor4_corr" name="temp_sensor4_corr" value ="{$temp_sensor4_corr}">
        </td></tr>
	</table>
	<INPUT TYPE="image" SRC="/img/submit.png" align="right">
	
</div>	

<div id="dashboard">
<h3>Ustawienia temperatury:</h3>
	<div class="temp_select">
		Temperatura w dzień:
		<input class="temp_select" type="text" readonly id="temp_day" name="temp_day" value ="{$temp_day}">
		<div id="slide_day" style="margin:10px;"></div>
	</div>
	<div class="temp_select">
		Temperatura w nocy:
		<input class="temp_select" type="text" readonly id="temp_night" name="temp_night" value ="{$temp_night}">
		<div id="slide_night" style="margin:10px;"></div>
	</div>					
	<div class="temp_select">
		Temperatura włączenia chłodzenia:
		<input class="temp_select" type="text" readonly id="temp_cool" name="temp_cool" value ="{$temp_cool}">
		<div id="slide_cool" style="margin:10px;"></div>
	</div>	
	<div class="temp_select">
		Histereza:
		<input class="temp_select" type="text" readonly id="hysteresis" name="hysteresis" value ="{$hysteresis}">
		<div id="slide_hysteresis" style="margin:10px;"></div>
	</div>					
	<INPUT TYPE="image" SRC="/img/submit.png" align="right">
	
</div>

<div id="dashboard">
<h3>Przyjazne nazwy wyjść:</h3>
	<table>
	{foreach from=$friendly_names item="friendly_name"}
		<tr><td>{$friendly_name.device} ({$friendly_name.output}):</td><td><input class="rest" type="text" id="device_{$friendly_name.device}" name="device_{$friendly_name.device}" value="{$friendly_name.fname}"></td></tr>
	{/foreach}
	</table>
	<INPUT TYPE="image" SRC="/img/submit.png" align="right">
	
</div>



</form>

{*
<table>
<tr><th>Klucz</th><th>Wartość</th></tr>
{foreach from=$settings item="entry"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$entry.key}</td>        
		<td>{$entry.value}</td>
    </tr>
{/foreach}
</table>
*}
{include "footer.tpl"}
