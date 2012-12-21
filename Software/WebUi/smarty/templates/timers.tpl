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

<div style="border:solid">

<form action="timers.php?op=add_new" method="post">

		Załączenie:
		<input class="time_select" type="text" name="ev_start" id="ev_start" value="00:00:00" />
		Wyłączenie:
		<input class="time_select" type="text" name="ev_stop" id="ev_stop" value="00:00:00" />
	Wyjście:
	<select name="line" id="line" >
		<option value="5">{$line_5}</option>
		<option value="6">{$line_6}</option>
	</select>	
	<input type="checkbox" name="d1" value="2" checked="checked"/>Pn
	<input type="checkbox" name="d2" value="4" checked="checked"/>Wt
	<input type="checkbox" name="d3" value="8" checked="checked"/>Śr
	<input type="checkbox" name="d4" value="16" checked="checked"/>Cz
	<input type="checkbox" name="d5" value="32" checked="checked"/>Pt
	<input type="checkbox" name="d6" value="64" checked="checked"/>So
	<input type="checkbox" name="d7" value="1" checked="checked"/>Nd
<input type="submit" value="Dodaj"></td>
</form>
</div>

<table>
<tr>
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
		<td>{$entry.t_start|date_format:"%H:%M:%S"}</td>
		<td>{$entry.t_stop|date_format:"%H:%M:%S"}</td>
		{if $entry.t_start<$entry.t_stop}{$duration = $entry.t_stop - $entry.t_start}{else}{$duration = 86400 -($entry.t_start - $entry.t_stop)}{/if}
		<td>{$duration|date_format:"%H:%M:%S"}</td>
		<td>{if $entry.line == 5}{$line_5}{/if}{if $entry.line == 6}{$line_6}{/if}</td>
		<td>{if $entry.day_of_week & 2}x{/if}</td>
		<td>{if $entry.day_of_week & 4}x{/if}</td>
		<td>{if $entry.day_of_week & 8}x{/if}</td>
		<td>{if $entry.day_of_week & 16}x{/if}</td>
		<td>{if $entry.day_of_week & 32}x{/if}</td>
		<td>{if $entry.day_of_week & 64}x{/if}</td>
		<td>{if $entry.day_of_week & 1}x{/if}</td>
		<td><a href="timers.php?op=del&id={$entry.id}"><img src="/img/delete_entry.png" title="Skasuj pozycję"></a></td>        
    </tr>
{/foreach}
</table>


{include "footer.tpl"}