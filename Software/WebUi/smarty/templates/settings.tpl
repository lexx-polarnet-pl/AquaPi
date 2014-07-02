{include "header.tpl"}

{literal}
<script type="text/javascript">
function f_initialize()
{
	//aktywowanie uzupelniania nazw w ponizszych polach
	var lokalizacja		= document.getElementById('location_tmp');
	var autocomplete	= new google.maps.places.Autocomplete(lokalizacja);
	
	google.maps.event.addListener(autocomplete, 'place_changed', function() {
		var place = autocomplete.getPlace();
		document.getElementById('link').href		= 'http://api.openweathermap.org/data/2.5/weather?q='+ place.name +'&mode=html&units=metric';
		document.getElementById('location').value	= place.name
		if(place.name.length>2)
			document.getElementById('linkdiv').style.display = '';
		else
			document.getElementById('linkdiv').style.display = 'none';
	});
}

google.maps.event.addDomListener(window, 'load', f_initialize);
</script>
{/literal}


<script type="text/javascript">

function disableF5(e)
{
	return 0;
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
<h3>Urządzenia:</h3>
	<table>
	<tr>
		<td>
			<select name="devices" id="devices"
				onmouseover="return overlib('Wybierz urządzenie do konfiguracji.');"
				onmouseout="return nd();"
				onchange="showdivs()">
				<option value="none">-- wybierz --</option>
				{foreach from=$devices item="device"}
				{if $device.device_name == '1wire' && $sensors_fs == 'FALSE'}
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
	<h3>Noc:</h3>
	&nbsp;Rozpoczęcie nocy: <input class="time_select" type="text" name="night_start" id="night_start" value="{if $CONFIG.night_start eq 0}00:00:00{else}{$CONFIG.night_start|utcdate_format:"%H:%M:%S"}{/if}"/>,
	zakończenie nocy: <input class="time_select" type="text" name="night_stop" id="night_stop" value="{if $CONFIG.night_stop eq 0}00:00:00{else}{$CONFIG.night_stop|utcdate_format:"%H:%M:%S"}{/if}" />.
	<BR><BR>
	<div class="temp_select">
		Korekcja temperatury w nocy:
		<input class="temp_select" type="text" readonly id="temp_night_corr" name="temp_night_corr" value ="{$CONFIG.temp_night_corr}">
		<div id="slide_temp_night_corr" style="margin:10px;"></div>	
	</div>	
	korekcja dotyczy czujników:<BR>
	{foreach from=$interfaces.1wire key=key item=sensor}
		<input type="checkbox" name="sensors[{$sensor.interface_id}][sensor_nightcorr]" {if $sensor.interface_nightcorr eq 1}checked="checked"{/if}
			{if $sensor.interface_disabled eq 1}onclick="return false" onmouseover="return overlib('Czujnik wyłaczony. Aktywuj go w zakładce 1-wire.');"
				onmouseout="return nd();"{/if} value="1">
			<span {if $sensor.interface_disabled eq 1}style="color:grey"
				onmouseover="return overlib('Czujnik wyłaczony. Aktywuj go najpierw w zakładce 1-wire.');"
				onmouseout="return nd();"
			{/if} >{$sensor.interface_name}</span><BR>
	{/foreach}
	<hr>
	<h3>Wykresy:</h3>
	Uprość wykresy:
	<input type="checkbox" name="simplify_graphs" value="1" {if $simplify_graphs eq 1}checked="checked"{/if}
			onmouseover="return overlib('Uproszczone wykresy. Pokazuje tylko zmiany.');"
			onmouseout="return nd();">
	<hr>
	<h3>Lokalizacja:</h3>
	<input type="input" id="location_tmp" value="{$CONFIG.location}"
			onmouseover="return overlib('W jakim mieście znajduje się system. Umożliwia wyświetlenie temperatury na wykresach.');"
			onmouseout="return nd();" onkeydown="checklen()">
	<input type="hidden" name="location" id="location" value="{$CONFIG.location}">
		
	<div id="linkdiv" style="display: none">
		<a id="link" href="">sprawdź poprawność nazwy</a>
	</div>
	{if $CONFIG.plugins.calendar eq 1}
	<hr>
	<h3>Kalendarz:</h3>
	<input type="input" id="calendar_days" name="calendar_days" value="{$CONFIG.calendar_days}" style="width:100px;"
		onmouseover="return overlib('Z jakiego okresu pokazywać nadchodzące wydarzenia?');"
		onmouseout="return nd();" >
	{/if}
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>

<!--Ustawienia sensorów temperatury-->
{include "settings_1wire.tpl"}
	
<!--GPIO-->
{include "settings_gpio.tpl"}

<!--PWM-->
{include "settings_pwm.tpl"}

<!--RELAYBOARD-->
{include "settings_relayboard.tpl"}

<!--Dummy-->
{include "settings_dummy.tpl"}

<!--System-->
{include "settings_system.tpl"}

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
function checklen()
{
	len	= document.getElementById('location_tmp').value.length;
	//console.log();
	if(len<4)
		document.getElementById('linkdiv').style.display = 'none';
}
</script>

</form>
{include "footer.tpl"}
