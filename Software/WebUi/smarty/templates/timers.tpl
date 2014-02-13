{include "header.tpl"}

<script>
	$(function() {
		
		$('#timeif').timepicker({
			timeFormat: "hh:mm:ss",
			showSecond: true,
			currentText: "Teraz",
			closeText: "Wybierz",
			timeOnlyTitle: "Wybierz czas",
			timeText: "Czas",
			hourText: "Godzina",
			minuteText: "Minuta",
			secondText: "Sekunda"
		});
		
		$('#ev_stop').timepicker({
			timeFormat: "hh:mm:ss",
			showSecond: true,
			currentText: "Teraz",
			closeText: "Wybierz",
			timeOnlyTitle: "Wybierz czas",
			timeText: "Czas",
			hourText: "Godzina",
			minuteText: "Minuta",
			secondText: "Sekunda"
		});		
	});
</script>

<!--ZDARZENIA CZASOWE-->
<div id="dashboard">
<h3>Dodanie zdarzenia czasowego:</h3>
<form action="timers.php?action=add" method="post">
			W dni tygodnia:
			<input type="checkbox" name="d2" value="1" checked="checked"/>Pn
			<input type="checkbox" name="d3" value="1" checked="checked"/>Wt
			<input type="checkbox" name="d4" value="1" checked="checked"/>Śr
			<input type="checkbox" name="d5" value="1" checked="checked"/>Cz
			<input type="checkbox" name="d6" value="1" checked="checked"/>Pt
			<input type="checkbox" name="d7" value="1" checked="checked"/>So
			<input type="checkbox" name="d1" value="1" checked="checked"/>Nd
			<br/>	
			O godzinie
			<input class="time_select" type="text" name="timeif" id="timeif" value="00:00:00" />
			<input type="hidden" name="type" id="type" value="1" />
			<select class="short" name="action" id="action">
				<option value="-1">wybierz</option>
				<option value="1">załącz</option>
				<option value="0">wyłącz</option>
			</select>
			wyjście
			<select name="interfaceidthen" id="interfaceidthen" >
				<option value="-1">wybierz</option>
				{foreach from=$interfaces.gpio item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
				{foreach from=$interfaces.relayboard item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
			</select>
			<br/>

	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>

<!--TIMERY TEMPERATUROWE-->
<div id="dashboard">
<h3>Dodanie nowego timera:</h3>
<form action="timers.php?action=add" method="post">
	<table>
	<tr>
		<td>Jeśli czujnik
			<select name="interfaceidif" id="interfaceidif" >
				<option value="-1">wybierz</option>
				{foreach from=$interfaces.1wire item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
			</select>
			wskaże
			<select class="short" name="direction" id="direction">
				<option value="-1">wybierz</option>
				<option value="1">></option>
				<option value="2"><</option>
			</select>
			<input class="vshort" type="text" name="value" id="value" value="26" /><small><small>(&plusmn;{$CONFIG.hysteresis})</small></small>&deg;C
			<input type="hidden" name="type" id="type" value="2" />
		</td>
	</tr>	
	<tr>
		<td>
			<select class="short" name="action" id="action">
				<option value="-1">wybierz</option>
				<option value="1">załącz</option>
				<option value="0">wyłącz</option>
			</select>
			wyjście
			<select name="interfaceidthen" id="interfaceidthen" >
				<option value="-1">wybierz</option>
				{foreach from=$interfaces.gpio item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
				{foreach from=$interfaces.relayboard item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
			</select>
		</td>
	</tr>	
	<tr>
		<td>
			Dni tygodnia
			<input type="checkbox" name="d2" value="1" checked="checked"/>Pn
			<input type="checkbox" name="d3" value="1" checked="checked"/>Wt
			<input type="checkbox" name="d4" value="1" checked="checked"/>Śr
			<input type="checkbox" name="d5" value="1" checked="checked"/>Cz
			<input type="checkbox" name="d6" value="1" checked="checked"/>Pt
			<input type="checkbox" name="d7" value="1" checked="checked"/>So
			<input type="checkbox" name="d1" value="1" checked="checked"/>Nd
		</td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>


<!--LISTA TIMERÓW-->
<div id="dashboard">
	<h3>Lista zdarzeń</h3>
	<table style="width:100%">
		<tr bgcolor="#aaaaaa">
			<th>Warunek
			<th>Akcja</th>
			<th>Wyjście</th>
			<th>Pn</th>
			<th>Wt</th>
			<th>Śr</th>
			<th>Cz</th>
			<th>Pt</th>
			<th>So</th>
			<th>Nd</th>
			<th>&nbsp;</th>
		</tr>
		{foreach from=$timers.time item="entry"}
		<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			    <td>O godzinie {if $entry.timer_timeif eq 0}00:00:00{else}{$entry.timer_timeif|date_format:"%H:%M:%S"}{/if} </td>
			    <td>{if $entry.timer_action eq 1}włącz{else}wyłącz{/if}</td>
			    <td>{$entry.timer_interfacethenname}</td>
			    <td align="center">{if $entry.timer_days.1 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.2 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.3 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.4 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.5 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.6 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.0 eq 1}x{/if}</td>
			    <td align="center"><a href="timers.php?action=delete&timerid={$entry.timer_id}"><img src="img/delete_entry.png" title="Skasuj pozycję"></a></td>        
		</tr>
		{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="12">Brak zdefiniowanych trigerów czasowych</td>
		</tr>
		{/foreach}
		{foreach from=$timers.1wire item="entry"}
		<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			    <td>Jeśli czujnik "{$entry.timer_interfaceifname}" wskazał {if $entry.timer_direction eq 1}>{else}<{/if} {$entry.timer_value}<small><small>(&plusmn;{$CONFIG.hysteresis})</small></small>&deg;C,</td>
			    <td>{if $entry.timer_action eq 1}włącz{else}wyłącz{/if}</td>
			    <td>{$entry.timer_interfacethenname}</td>
			    <td align="center">{if $entry.timer_days.1 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.2 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.3 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.4 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.5 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.6 eq 1}x{/if}</td>
			    <td align="center">{if $entry.timer_days.0 eq 1}x{/if}</td>
			    <td align="center"><a href="timers.php?action=delete&timerid={$entry.timer_id}"><img src="img/delete_entry.png" title="Skasuj pozycję"></a></td>        
		</tr>
		{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="12">Brak zdefiniowanych trigerów 1-wire</td>
		</tr>
		{/foreach}
	</table>
</div>

{include "footer.tpl"}