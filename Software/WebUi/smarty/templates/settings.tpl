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
		value: {$hysteresis|default:1}
	});
	
//	$('#day_start').timepicker({
//		timeFormat: "hh:mm:ss",
//		showSecond: true,
//		currentText: "Teraz",
//		closeText: "Wybierz",
//		timeOnlyTitle: "Wybierz czas",
//		timeText: "Czas",
//		hourText: "Godzina",
//		minuteText: "Minuta",
//		secondText: "Sekunda"
//	});
//	
//	$('#day_stop').timepicker({
//		timeFormat: "hh:mm:ss",
//		showSecond: true,
//		currentText: "Teraz",
//		closeText: "Wybierz",
//		timeOnlyTitle: "Wybierz czas",
//		timeText: "Czas",
//		hourText: "Godzina",
//		minuteText: "Minuta",
//		secondText: "Sekunda"
//	});		
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
	<!--<input class="time_select" type="text" name="day_start" id="day_start" value="$day_start"/>-->
	<!--<input class="time_select" type="text" name="day_stop" id="day_stop" value="$day_stop" />-->
	<div class="temp_select">
		Histereza:
		<input class="temp_select" type="text" readonly id="hysteresis" name="hysteresis" value ="{$hysteresis}">
		<div id="slide_hysteresis" style="margin:10px;"></div>
	</div>	
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

<!--Relayboard-->
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
		//console.log(devices[i]);
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

{include "footer.tpl"}
