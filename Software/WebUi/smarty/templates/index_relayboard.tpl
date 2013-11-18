<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
{foreach from=$interfaces.relayboard item="device"}
	    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			<td>{$device.interface_name}</td>     
			<td>
				    {if $device.interface_icon}
						<img src="img/{$device.interface_icon}">
				    {else}
						<img src="img/device.png">
				    {/if}
				    <img src="img/{if $device.interface_state.stat_value == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px">
			</td>
	    </tr>
{/foreach}
</table>
