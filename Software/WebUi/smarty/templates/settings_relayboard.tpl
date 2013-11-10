<div id="dashboard">
<h3>Relayboard:</h3>
	<table>
	{foreach from=$relayboard key=key item=relay}
	<tr>
	    <td onmouseover="return overlib('{if $relay.relay_type eq 0}Gniazdo NO (Normal Open - normalnie otwarty), przerwa - rezystancja nieskończenie wielka. {else}Gniazdo NC (Normal Connect - normalnie zwarty), zwarcie - rezystancja równa zero. {/if}');"
				onmouseout="return nd();">
		relay {$relay.relay_id} ({if $relay.relay_type eq 0}NO{else}NC{/if}):&nbsp;
	    </td>
	    <td>
		<input class="long" name="relay[{$relay.relay_id}][relay_name]" value="{$relay.relay_name}"
				onmouseover="return overlib('Podaj nową nazwę przekaźnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    <td>
	        przełączone:&nbsp;{if $relay.relay_state eq 1}<img src="img/on.png">{else}<img src="img/off.png">{/if}&nbsp;&nbsp;&nbsp;
	    </td>
	    <td>
	        urządzenie:&nbsp;{if $relay.relay_enable eq 1}<img src="img/on.png">{else}<img src="img/off.png">{/if}
	    </td>
	</tr>
	{/foreach}
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>	
