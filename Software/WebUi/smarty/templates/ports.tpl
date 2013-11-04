<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
{foreach from=$devices item="device"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device.fname}</td>     
		<td>
		{if $device.device == "light"}
			<img src="/img/day.png">
		{elseif $device.device == "heater"}
			<img src="/img/heater.png">
		{elseif $device.device == "cooling"}
			<img src="/img/cooling.png">
		{else}
			<img src="/img/device.png">
		{/if}
		<img src="/img/{if $device.output_state == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px"></td>
    </tr>
{/foreach}
</table>
