<div id="dashboard_relayboard" style="display: none">
	<h3>Relayboard:</h3>
	{if $interfaces.relayboard}
	<table>
	<tr>
		<td colspan="5"></td>
		<td><img src="img/chart_thumb.png" onmouseover="return overlib('Pokazuj czujnik na wykresie.');" onmouseout="return nd();"></td>
	</tr>
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
				<option {if $relay.interface_conf eq 0}selected{/if} value="0">NO</option>
				<option {if $relay.interface_conf eq 1}selected{/if} value="1">NC</option>
			</select> 
		</td>
		<td>
			<input type="checkbox" name="relays[{$relay.interface_id}][relay_draw]" value="1" {if $relay.interface_draw eq 1}checked="checked"{/if}
				{if $relay.interface_disabled eq 1}onclick="return false" onmouseover="return overlib('Przekaźnik wyłaczony. Aktywuj go najpierw.');"
				onmouseout="return nd();"{else}
				onmouseover="return overlib('Pokazuj przekaźnik na wykresie.');"
				onmouseout="return nd();"{/if}></td>
	</tr>
	{/foreach}
	</table>
	<div>
		<p style="text-align: justify;"><img src="img/ark3.jpg" alt="ark3" style="float:right; margin:6px">
		Przekaźniki RB po włączeniu urządzenia są w stanie logicznym 0 (off/wyłączone). Oznacza to, że pomiedzy 1 a 2 jest przerwa, a pomiędzy 2 i 3 jest zwarcie. Urządzenie podłaczone do pinów 1 i 2 będzie włączone kiedy przekaźnik będzie właczony i wyłączone kiedy przekaźnik jest wyłączony. Ten rodzaj połączenia reprezentuje typ wyjścia NO.<BR>
		Natomiast urządzenie podłączone do pinów 2 i 3 zachowuje się odwrotnie. Właczenie przekaźnika powoduje wyłaczenie urządzenia i analogicznie wyłaczenie przekaźnika włącza urzadzenie. Ten rodzaj połączenia reprezentuje typ wyjścia NC.<br>
		Używanie różnych typów wyjść może zabezpieczyć nas na wypadek awarii prądu lub restartu urządzenia. Wszystkie przekaźniki RB będą wtedy wyłączone i tylko od nas zależy czy w sytuacji kiedy nic nie steruje RB chcemy aby poszczególne urządzenia działały czy nie. W przypadku kiedy urządzenie jest wyłaczane raz dziennie na parę minut (np filtr podczas karmienia ryb) użycie typu NC pozwoli także na oszczedność prądu - przekaźnik pobiera prąd tylko przez parę minut kiedy filtr jest wyłączony.
		</p>
		
	</div>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	
