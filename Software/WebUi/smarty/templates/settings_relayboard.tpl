<div id="dashboard_relayboard" style="display: none">
<h3>Relayboard:</h3>
	<table>
	{foreach from=$interfaces.relayboard key=key item=relay}
	<tr>
	    <td>
		relay {$relay.interface_addressshort}
	    </td>
	    <td>
		<select name="relays[{$relay.interface_id}][relay_conf]" id="relays[{$relay.interface_id}][relay_conf]"
				onmouseover="return overlib('Wybierz typ przekaźnika.');"
				onmouseout="return nd();">
		    <option {if $relay.interface_conf eq 0}selected="selected"{/if} value="0">NO</option>
		    <option {if $relay.interface_conf eq 1}selected="selected"{/if} value="1">NC</option>
		</select>
	    </td>
	    <td>
		<select class="medium"
			onmouseover="return overlib('Wybierz ikonę dla wyjścia.');"
			onmouseout="return nd();">
			<option class="imagebacked" style="background-image:url(img/device.png);">&nbsp;device.png</option>
			{foreach $icons item=icon}
			<option class="imagebacked" style="background-image:url(img/{$icon});">&nbsp;{$icon}</option>
			{/foreach}
		</select> 
	    </td>
	</tr>
	{/foreach}
	</table>
	<BR>
	Gniazdo NO (Normal Open - normalnie otwarty) -<BR>
	przy wyłączonym przekaźniku, przerwa - rezystancja nieskończenie wielka. <BR>
	Gniazdo NC (Normal Connect - normalnie zwarty) -<BR>
	przy wyłączonym przekaźniku, zwarcie - rezystancja równa zero. 
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>	
