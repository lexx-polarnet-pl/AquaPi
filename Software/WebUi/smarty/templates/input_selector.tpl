<!-- demo jak wyświetlić wszystkie jeszcze nie ustawione wejścia i wyjścia -->
<div id="dashboard">
<h3>Dodaj nowe wejście:</h3>
<script>
function ChangeInput()
{
	var devices = new Array();
	{foreach from=$device_list->devicelist->device item="device"}
	devices.push(Array('{$device->address}','{$device->description}','{$device->fully_editable_address}'));
	{/foreach}

	var length = devices.length;
	var e = document.getElementById("InputAddressSelector").value;
	var FullyEditableVisible = false;
	
	for (var i = 0; i < length; i++)
	{
		var item = devices[i];
		if (item[0] == e) 
		{
			if (item[2] == 'yes') FullyEditableVisible = true;
		}
	}

	if (FullyEditableVisible) 
	{
		//document.getElementById('FullyEditable').style.display		= 'block';
		//document.getElementById('FullyEditable').
		//document.getElementById('FullyEditable').value = "";
		document.getElementById('FullyEditable').disabled = false;
	}
	else
	{
		//document.getElementById('FullyEditable').style.display		= 'none';
		document.getElementById('FullyEditable').value = "";
		document.getElementById('FullyEditable').disabled = true;
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
<form action="settings.php?action=add_input" method="post">
Przyjazna nazwa:<input name="InputFriendlyName"><br/>
Adres sprzętowy:
<select name="InputAddressSelector" id="InputAddressSelector" onchange="ChangeInput()">
{foreach from=$device_list->devicelist->device item="device"}
	{if ($device->input == 'yes') && !($device->configured == 'yes')}
		<option value="{$device->address}">{$device->description}</option>
	{/if}
{/foreach}
</select><br/>
<div id="FullyEditable2">
Dodatkowy adres
<input name="FullyEditable" id="FullyEditable"><br/>
</div>
Ikona
<img src="img/alert.png" id="icon-prev"><select name="InputIconSelector" id="InputIconSelector" onchange="ChangeIcon()">
	{foreach $icons item=icon}
	<option class="imagebacked" style="background-image:url(img/{$icon});">{$icon}</option>
	{/foreach}
</select> 
<br/>Jednostka
<select name="InputUom">
	<option value="none">Brak</option>
	{foreach from=$units item=unit}
	<option value="{$unit.unit_id}">{$unit.unit_name}</option>
	{/foreach}
</select>
<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>

<div id="dashboard">
wyjścia
<select name="outputs" id="outputs">
{foreach from=$device_list->devicelist->device item="device"}
	{if ($device->output == 'yes') && !($device->configured == 'yes')}
		<option value="{$device->address}">{$device->description}</option>
	{/if}
{/foreach}
</select>


</div>
<!-- koniec dema -->