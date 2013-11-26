<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
{foreach from=$interfaces.relayboard item="interface"}
	    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			<td>{$interface.interface_name}</td>     
			<td>
				    {if $interface.interface_icon}
						<img src="img/{$interface.interface_icon}">
				    {else}
						<img src="img/device.png">
				    {/if}
				    <img src="img/{if $interface.interface_state.stat_value == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px">
			</td>
	    </tr>
{/foreach}
</table>
