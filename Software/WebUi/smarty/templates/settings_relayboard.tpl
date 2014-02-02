<div id="dashboard_relayboard" style="display: none">
	<h3>Relayboard:</h3>
	<table>
	{foreach from=$interfaces.relayboard  key=key item=relay}
	<tr>
	    <td>
		relay {$key+1}
	    </td>
	    <td>
		<input class="long" name="relays[{$relay.interface_id}][relay_name]" value="{$relay.interface_name}"
				onmouseover="return overlib('Podaj nową nazwę przekaźnika. Minimum 2 litery.');"
				onmouseout="return nd();">
	    </td>
	    </td>
	    <td style="width: 75px; text-align: right;">
		<img src="img/{$relay.interface_icon}">
	    </td>
	    <td>
		<select class="medium" name="relays[{$relay.interface_id}][relay_icon]"
			onmouseover="return overlib('Wybierz ikonę dla wyjścia.');"
			onmouseout="return nd();">
			<option class="imagebacked" style="background-image:url(img/device.png);" {if $relay.interface_icon eq "device.png"}selected{/if}>device.png</option>
			{foreach $icons item=icon}
			<option class="imagebacked" style="background-image:url(img/{$icon});" {if $relay.interface_icon eq $icon}selected{/if}>{$icon}</option>
			{/foreach}
		</select> 
	    </td>
	    <td>
		<select class="medium" name="relays[{$relay.interface_id}][relay_conf]"
			onmouseover="return overlib('Wybierz typ wyjścia. Gniazdo NO (Normal Open - normalnie otwarty), przerwa - rezystancja nieskończenie wielka. Gniazdo NC (Normal Connect - normalnie zwarty), zwarcie - rezystancja równa zero.');"
			onmouseout="return nd();">
			<option {if $relay.interface_conf eq 0}selected{/if}>NO</option>
			<option {if $relay.interface_conf eq 1}selected{/if}>NC</option>
		</select> 
	    </td>
	</tr>
	{/foreach}
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>	
