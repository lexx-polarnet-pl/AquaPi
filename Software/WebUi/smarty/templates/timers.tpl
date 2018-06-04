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
		
		$('#timeifpwm').timepicker({
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

<!--LISTA TIMERÓW-->
<div id="dashboard">
	<h3>Lista zdarzeń</h3>
	<table style="width:100%">
		<tr bgcolor="#aaaaaa">
			<th>Godzina
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
		
		<!--ZDARZENIA CZASOWE-->
		{foreach from=$timers.time item="entry"}
		<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
			    <td>{if $entry.timer_timeif eq 0}00:00:00{else}{$entry.timer_timeif|utcdate_format:"%H:%M:%S"}{/if} </td>
			    <td><div id="timer_action_{$entry.timer_id}"></div></td>
			    <td>{$entry.timer_interfacethenname}</td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.1 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.2 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.3 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.4 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.5 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.6 eq 1} checked{/if}></td>
			    <td align="center"><input type="checkbox"{if $entry.timer_days.0 eq 1} checked{/if}></td>
			    <td align="center"><a href="timers.php?action=delete&timerid={$entry.timer_id}"><img src="img/delete.png" title="Skasuj pozycję"></a></td>        
		</tr>
		<script>
		$('#timer_action_{$entry.timer_id}').btnSwitch({
			Theme: 'Swipe',
			OnText: "Załącz",
			OffText: "Wyłącz",
			ToggleState:{if $entry.timer_action eq 1}true{else}false{/if}
		});
		</script>
		{foreachelse}
		<tr bgcolor="#cccccc">
			<td colspan="12">Brak zdefiniowanych zdarzeń czasowych</td>
		</tr>
		{/foreach}
	</table>
</div>

<!--ZDARZENIA CZASOWE-->
<div id="dashboard">
<h3>Dodaj nowe zdarzenie</h3>
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
				{foreach from=$interfaces item="interface"}
					{if $interface.interface_type==2}
						<option value="{$interface.interface_id}"{if $interface.interface_id == $CONFIG.temp_interface_cool} selected{/if}>{$interface.interface_name}</option>
					{/if}
				{/foreach}
			</select>
			<br/>

	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>

{include "footer.tpl"}
