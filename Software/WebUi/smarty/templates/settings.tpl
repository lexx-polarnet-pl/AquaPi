{include "header.tpl"}

<script type="text/javascript">
function disableF5(e)
{
	if ((e.which || e.keyCode) == 116 || (e.which || e.keyCode) == 82)
	{
		alert('Reload niedozwolony');
		e.preventDefault();
	}
	
};

$(document).ready(function(){
     $(document).on("keydown", disableF5);
});

$(function() {
	$("#slide_hysteresis").slider({
		slide: function(event, ui) { 
				document.getElementById('hysteresis').value = ui.value.toFixed(1);
		},
		step: 0.1,
		min: 0,
		max: 1,
		value: {$CONFIG.hysteresis|default:1}
	});
	
	$('#night_start').timepicker({
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
	
	$('#night_stop').timepicker({
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
	$("#slide_temp_night_corr").slider({
		slide: function(event, ui) { 
				document.getElementById('temp_night_corr').value = ui.value.toFixed(1);
		},
		step: 0.1,
		min: -2,
		max: 2,
		value: {$CONFIG.temp_night_corr|default:-0.5}
	});
});
</script>

<form action="settings.php" method="post">

<div id="dashboard">
<h3>Devices:</h3>
	<table>
	<tr>
		<td>
			<select name="devices" id="devices"
				onmouseover="return overlib('Wybierz urządzenie do konfiguracji.');"
				onmouseout="return nd();"
				onchange="showdivs()">
				<option value="none">-- wybierz --</option>
				{foreach from=$devices item="device"}
				{if $device.device_name eq '1wire' && $sensors_fs == 'FALSE'}
				{else}
				<option>{$device.device_name}</option>
				{/if}
				{/foreach}
			</select>
		</td>
	</tr>
	<tr>
		<td>
			{foreach from=$devices item="device"}
				<div id="{$device.device_name}" style="display: none">
					<select name="device_{$device.device_name}" id="devices_{$device.device_name}">
						<option value="1" {if $device.device_disabled eq 1} selected="selected"{/if}>Wyłączone</option>
						<option value="0" {if $device.device_disabled eq 0} selected="selected"{/if}>Włączone</option>
					</select>
					<a href="?action=delete&device_id={$device.device_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć to urządzenie?');"
							onmouseover="return overlib('Usunięcie urządzenia');"
							onmouseout="return nd();">
						<img align="right" src="img/off.png"></a>
				</div>
			{/foreach}
		</td>
	</tr>
	</table>
	<BR><HR>
	&nbsp;Rozpoczęcie nocy: <input class="time_select" type="text" name="night_start" id="night_start" value="{$CONFIG.night_start|date_format:"%H:%M:%S"}"/>,
	zakończenie nocy: <input class="time_select" type="text" name="night_stop" id="night_stop" value="{$CONFIG.night_stop|date_format:"%H:%M:%S"}" />.
	<BR><BR>
	<div class="temp_select">
		Korekcja temperatury w nocy:
		<input class="temp_select" type="text" readonly id="temp_night_corr" name="temp_night_corr" value ="{$CONFIG.temp_night_corr}">
		<div id="slide_temp_night_corr" style="margin:10px;"></div>	
	</div>	
	<div class="temp_select">
		Histereza:
		<input class="temp_select" type="text" readonly id="hysteresis" name="hysteresis" value ="{$CONFIG.hysteresis}">
		<div id="slide_hysteresis" style="margin:10px;"></div>	
	</div>
	Uprość wykresy:
	<input type="checkbox" name="simplify_graphs" value="1" {if $simplify_graphs eq 1}checked="checked"{/if}
			onmouseover="return overlib('Uproszczone wykresy. Pokazuje tylko zmiany.');"
			onmouseout="return nd();">
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>

<!--Ustawienia sensorów temperatury-->
{if $sensors_fs != 'FALSE'}
	{include "settings_sensors_table.tpl"}
{/if}
	
<!--GPIO-->
{include "settings_gpio.tpl"}

<!--PWM-->
{include "settings_pwm.tpl"}

<!--RELAYBOARD-->
{include "settings_relayboard.tpl"}

<!--Dummy-->
{include "settings_dummy.tpl"}

</form>

<script>
function showdivs()
{
	
	var devices = new Array();
	{foreach from=$devices item="device"}
	devices.push('{$device.device_name}');
	{/foreach}

	var length = devices.length;
	//ukrywam wszystkie elementy
	for (var i = 0; i < length; i++)
	{
		console.log(devices[i]);
		document.getElementById(devices[i]).style.display		= 'none';
		document.getElementById('dashboard_'+devices[i]).style.display	= 'none';
	}
	
	//pokazuje tylko pasujacy do wybranego
	var e = document.getElementById("devices");
	var name = e.options[e.selectedIndex].value;
	if(name!='none')
	{
		document.getElementById(name).style.display		= 'inline-block';
		document.getElementById('dashboard_'+name).style.display= '';
	}
}
</script>

</form>
{include "footer.tpl"}
