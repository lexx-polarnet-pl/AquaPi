<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
{foreach from=$status.aquapi.devices.device item="device"}
	{if $device.type == 2 && (strpos($device.address, "gpio") !== false || strpos($device.address, "dummy") !== false)}
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device.name}</td>     
		<td>	
			<a href="#" class="topopup" onclick="SetMyPopup('{$device.name}','{$device.id}','{if $device.state == -1}Nieokreślony{elseif $device.state == 1}Włączony{else}Wyłączony{/if}');">
				<div id="device{if $device.override_value == -1}-auto{/if}{if $device.state == 1}-on{elseif $device.state == 0}-off{/if}"
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
