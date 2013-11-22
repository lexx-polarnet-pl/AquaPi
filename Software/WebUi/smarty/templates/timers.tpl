{include "header.tpl"}

<script>
	$(function() {
		
		$('#ev_start').timepicker({
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

<!--TIMERY GODZINNE-->
<div id="dashboard">
<h3>Dodanie nowego timera:</h3>
<form action="timers.php?action=add" method="post">
	<table>
	<tr>
		<td>
			Jesli godzina
			<select name="device" id="device" class="short">
				<option value="-1">wybierz</option>
				<option value="1">></option>
				<option value="3"><</option>
			</select>
			<input class="time_select" type="text" name="ev_start" id="ev_start" value="00:00:00" />
		</td>
	</tr>
	<tr>
		<td>
			<select name="action" id="action" class="short">
				<option value="-1">wybierz</option>
				<option value="1">załącz</option>
				<option value="0">wyłącz</option>
			</select>
			wyjście
			<select name="device" id="device" >
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
			Dni tygodnia:
			<input type="checkbox" name="d1" value="2"  checked="checked"/>Pn
			<input type="checkbox" name="d2" value="4"  checked="checked"/>Wt
			<input type="checkbox" name="d3" value="8"  checked="checked"/>Śr
			<input type="checkbox" name="d4" value="16" checked="checked"/>Cz
			<input type="checkbox" name="d5" value="32" checked="checked"/>Pt
			<input type="checkbox" name="d6" value="64" checked="checked"/>So
			<input type="checkbox" name="d7" value="1"  checked="checked"/>Nd
		</td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>

<!--LISTA TIMERÓW-->
<div id="dashboard">
	<h3>Lista timerów</h3>
	<table style="width:100%">
		<tr bgcolor="#aaaaaa">
			<th>Start</th>
			<th>Stop</th>
			<th>Czas</th>
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
		{foreach from=$timers item="entry"}
		<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			    {$t_start = $entry.t_start+86400}
			    {$t_stop = $entry.t_stop+86400}
			    {if $entry.t_start<$entry.t_stop}{$duration = $entry.t_stop - $entry.t_start}{else}{$duration = 86400 -($entry.t_start - $entry.t_stop)}{/if}
			    <td>{$t_start|date_format:"%H:%M:%S"}</td>
			    <td>{$t_stop|date_format:"%H:%M:%S"}</td>
			    <td>{$duration|date_format:"%H:%M:%S"}</td>
			    <td>{$entry.fname}</td>
			    <td align="center">{if $entry.day_of_week & 2}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 4}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 8}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 16}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 32}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 64}x{/if}</td>
			    <td align="center">{if $entry.day_of_week & 1}x{/if}</td>
			    <td align="center"><a href="timers.php?action=del&id={$entry.id}"><img src="img/delete_entry.png" title="Skasuj pozycję"></a></td>        
		</tr>
		{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="12">Brak zdefiniowanych timerów</td>
		</tr>
		{/foreach}
	</table>
</div>



<!--TIMERY TEMPERATUROWE-->
<div id="dashboard">
<h3>Dodanie nowego timera:</h3>
<form action="timers.php?action=add" method="post">
	<table>
	<tr>
		<td>Jeśli czujnik
			<select name="device" id="device" >
				<option value="-1">wybierz</option>
				{foreach from=$interfaces.1wire item=interface}
				<option value="{$interface.interface_id}">{$interface.interface_name} ({$interface.interface_address})</option>
				{/foreach}
			</select>
			wskaże
			<select name="device" id="device" class="short">
				<option value="-1">wybierz</option>
				<option value="1">></option>
				<option value="3"><</option>
			</select>
			<input class="vshort" type="text" name="temperature" id="temperature" value="26" />&deg;C
		</td>
	</tr>	
	<tr>
		<td>
			<select name="action" id="action" class="short">
				<option value="-1">wybierz</option>
				<option value="1">załącz</option>
				<option value="0">wyłącz</option>
			</select>
			wyjście
			<select name="device" id="device" >
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
			<input type="checkbox" name="d1" value="2"  checked="checked"/>Pn
			<input type="checkbox" name="d2" value="4"  checked="checked"/>Wt
			<input type="checkbox" name="d3" value="8"  checked="checked"/>Śr
			<input type="checkbox" name="d4" value="16" checked="checked"/>Cz
			<input type="checkbox" name="d5" value="32" checked="checked"/>Pt
			<input type="checkbox" name="d6" value="64" checked="checked"/>So
			<input type="checkbox" name="d7" value="1"  checked="checked"/>Nd
		</td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>
{include "footer.tpl"}