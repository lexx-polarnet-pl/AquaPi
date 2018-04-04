{include "header.tpl"}
<div id="dashboard">
<h3>Skonfigurowane urządzenia</h3>
<table style="width:100%">
<tr bgcolor="#aaaaaa"><th></th><th>Nazwa</th><th>Adres</th><th>Tryb</th><th></th></tr>
{foreach from=$devices item="device"}
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{if $device.interface_icon}<img src="img/{$device.interface_icon}">{/if}</td>
		<td>{$device.interface_name}</td> 
		<td>{$device.interface_address}</td>
		<td>{if $device.interface_type==1}Wejście{elseif $device.interface_type==2}Wyjście binarne{elseif $device.interface_type==3}Wyjście PWM{/if}</td>
		<td>
			<a href="?action=delete&device_id={$device.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć to urządzenie?');" title="Usunięcie urządzenia">
				<img align="right" src="img/off.png">
			</a>
		</td>
	</tr>
{/foreach}
</table>
</div>

<div id="dashboard">
<h3>Dodaj nowe wejście lub wyjście</h3>
<script>
function ChangeInput()
{
	var devices = new Array();
	{foreach from=$device_list->devicelist->device item="device"}
	devices.push(Array('{$device->address}','{$device->description}','{$device->fully_editable_address}', '{$device->prompt}', '{$device->input}', '{$device->output}', '{$device->pwm}'));
	{/foreach}

	var length = devices.length;
	var e = document.getElementById("InputAddressSelector").value;
	var FullyEditableVisible = false;
	
	for (var i = 0; i < length; i++)
	{
		var item = devices[i];
		if (item[0] == e) 
		{
			if (item[2] == 'yes') {
				document.getElementById('FullyEditable').disabled = false;
				document.getElementById('FullyEditablePrompt').innerHTML = item[3];
			} else 	{
				document.getElementById('FullyEditable').value = "";
				document.getElementById('FullyEditable').disabled = true;
			}
			if (item[4] == 'yes') {
				document.getElementById('IOIn').disabled = false;

			} else {
				document.getElementById('IOIn').disabled = true;
			}
			if (item[5] == 'yes') {
				document.getElementById('IOOut').disabled = false;				
			} else {
				document.getElementById('IOOut').disabled = true;
			}			
			if (item[6] == 'yes') {
				document.getElementById('IOOutPWM').disabled = false;				
			} else {
				document.getElementById('IOOutPWM').disabled = true;
			}				
			if (item[5] == 'yes' && item [4] == 'no') document.getElementById('IOOut').checked = true;
			if (item[4] == 'yes' && item [5] == 'no') document.getElementById('IOIn').checked = true;
		}
	}
}

function ChangeIcon()
{
	var icon = document.getElementById("InputIconSelector").value;
	document.getElementById("icon-prev").setAttribute("src","img/" + icon);

}
window.onload = load;

function load()
{
	ChangeInput();
	ChangeIcon();
}
</script>

<form action="ioconf.php?action=add" method="post">
<table>
<tr><td>Przyjazna nazwa</td><td><input name="InputFriendlyName" style="width:200px"></td></tr>
<tr><td>Adres sprzętowy</td><td>
<select name="InputAddressSelector" id="InputAddressSelector" onchange="ChangeInput()" style="width:200px">
{foreach from=$device_list->devicelist->device item="device"}
	{if ($device->input == 'yes') && !($device->configured == 'yes')}
		<option value="{$device->address}">{$device->description}</option>
	{/if}
{/foreach}
</select></td></tr>
<tr><td><span id="FullyEditablePrompt">Dodatkowy adres</span></td><td><input name="FullyEditable" id="FullyEditable" style="width:200px"><br/></td></tr>
<tr><td>Ikona<img src="img/alert.png" id="icon-prev"style="float:right"></td><td>
<select name="InputIconSelector" id="InputIconSelector" onchange="ChangeIcon()" style="width:200px">
	{foreach $icons item=icon}
	<option class="imagebacked" style="background-image:url(img/{$icon});">{$icon}</option>
	{/foreach}
</select></td></tr>
<tr><td>Ustaw jako</td><td>
<select name="InputModeSelector" id="InputNameSelector">
	<option value="1" id="IOIn">Wejście</option>
	<option value="2" id="IOOut">Wyjście binarne</option>
	<option value="3" id="IOOutPWM">Wyjście PWM</option>
</select>
</td></tr>
</table>
<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>


{include "footer.tpl"}
