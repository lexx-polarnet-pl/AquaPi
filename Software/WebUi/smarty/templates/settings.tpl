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

<div style="float: right; width: 48%; border:solid;">
	<div>
		Rozpoczęcie dnia:
		<input class="time_select" type="text" name="day_start" id="day_start" value="{$day_start}" />
	</div>					
	<div>
		Zakończenie dnia:
		<input class="time_select" type="text" name="day_stop" id="day_stop" value="{$day_stop}" />
	</div>	
</div>
<div style="width:48%">
	<div class="temp_select">
		Temperatura w dzień:
		<input class="temp_select" type="text" readonly id="temp_day" name="temp_day" value ="{$temp_day}">
		<div id="slide_day" style="margin-top:10px;"></div>
	</div>
	<div class="temp_select">
		Temperatura w nocy:
		<input class="temp_select" type="text" readonly id="temp_night" name="temp_night" value ="{$temp_night}">
		<div id="slide_night" style="margin-top:10px;"></div>
	</div>					
	<div class="temp_select">
		Histereza:
		<input class="temp_select" type="text" readonly id="hysteresis" name="hysteresis" value ="{$hysteresis}">
		<div id="slide_hysteresis" style="margin-top:10px;"></div>
	</div>	
</div>
<div>
	Sensor temperatury:
	<select name="temp_sensor" id="temp_sensor" >
		{foreach from=$temp_sensors item="sensor_id"}
		<option{if $sensor_id == $temp_sensor} selected="selected"{/if}>{$sensor_id}</option>
		{/foreach}
	</select>	
</div>	
<input type="submit" value="Zapisz"></td>
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