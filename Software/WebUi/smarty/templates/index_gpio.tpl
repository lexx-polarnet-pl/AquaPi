<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
<!--foreach from=$interfaces.gpio item="device"
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device.interface_name}</td>     
		<td>
			{if $device.interface_icon}
				    <img src="img/{$device.interface_icon}">
			{else}
				    <img src="img/device.png">
			{/if}
		
		<img src="img/{if $device.interface_state.stat_value == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px"></td>
    </tr>
/foreach-->
{foreach from=$status.aquapi.devices.device item="device"}
	{if $device.type == 2 && strpos($device.address, "gpio") !== false}
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device.name}</td>     
		<td>	
			<a href="#" class="topopup" onclick="SetMyPopup('{$device.name}','{if $device.state == -1}Nieokreślony{elseif $device.state == 1}Włączony{else}Wyłączony{/if}');">
				<div id="{if $device.state == -1}device{elseif $device.state == 1}device-on{else}device-off{/if}"
					title="{if $device.state == -1}Nieokreślony{elseif $device.state == 1}Włączony{else}Wyłączony{/if}">
					{if $icons[{$device.id}]}
							<img src="img/{$icons[{$device.id}]}">
					{else}
							<img src="img/device.png">
					{/if}
				</div>
			</a>
		</td>
	</tr>
	{/if}
{/foreach}
</table>
