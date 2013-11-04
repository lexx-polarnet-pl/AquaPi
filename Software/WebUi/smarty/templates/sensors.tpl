<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czujnik temp.</th><th>Wartość</th></tr>
    <tr bgcolor="#cccccc">
		<td>Zbiornik główny</td>     
		<td>{if $temp1==''}--.--{else}{$temp1|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#dddddd">
		<td>Pomocniczy 1</td>     
		<td>{if $temp2==''}--.--{else}{$temp2|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#cccccc">
		<td>Pomocniczy 2</td>     
		<td>{if $temp3==''}--.--{else}{$temp3|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
    <tr bgcolor="#dddddd">
		<td>Pomocniczy 3</td>     
		<td>{if $temp4==''}--.--{else}{$temp4|string_format:"%.2f"}{/if}&deg;C</td>
	</tr>
</table>
