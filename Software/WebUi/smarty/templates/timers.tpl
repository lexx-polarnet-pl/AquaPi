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
{foreach from=$timers.time item="entry"}
		$('#timers_{$entry.timer_id}').timepicker({
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
{/foreach}	
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
				<td><input class="timers_{$entry.timer_id}" type="text" name="timers_{$entry.timer_id}" id="timers_{$entry.timer_id}" value="{if $entry.timer_timeif eq 0}00:00:00{else}{$entry.timer_timeif|utcdate_format:"%H:%M:%S"}{/if}"/></td>
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
			OnValue: 1,
			OffValue: 0,				
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
			<input type="hidden" name="action" id="action" class="action" value="0"/>
			<div id="actionsw" name="actionsw"></div>
			<script>
			$('#actionsw').btnSwitch({
				Theme: 'Swipe',
				OnText: "Załącz",
				OffText: "Wyłącz",
				OnCallback: function(data) {
					$('.action').attr('value', '1');
				},	
				OffCallback: function(data) {
					$('.action').attr('value', '0');
				},	
				OnValue: '1',
				OffValue: '0',
				HiddenInputId: true		
			});
			</script>			
			wyjście
			<!-- <select name="interfaceidthen" id="interfaceidthen" >
				<option value="-1">wybierz</option>
				{foreach from=$interfaces item="interface"}
					{if $interface.interface_type==2}
						<option value="{$interface.interface_id}"{if $interface.interface_id == $CONFIG.temp_interface_cool} selected{/if}>{$interface.interface_name}</option>
					{/if}
				{/foreach}
				</select>
			-->	
				<input type="hidden" name="interfaceidthen" class="interfaceidthen">
				<select id="DeviceSelector">
				{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
				<option value="{$interface.interface_id}" data-imagesrc="img/devices/{$interface.interface_icon}"{if $CONFIG.light_interface==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
				{/if}{/foreach}
				</select>	
			<script>
			$('#DeviceSelector').ddslick({
				width:200,
				height:300,
				imagePosition:"left",
				onSelected: function(data) {
					$('.interfaceidthen').attr('value', data.selectedData.value);
				}	
			});
			</script>	
			<br/>

	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>
</div>

{include "footer.tpl"}
