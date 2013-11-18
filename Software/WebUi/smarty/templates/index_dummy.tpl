<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czujniki temperatury</th><th>Wartość</th></tr>
    {foreach from=$interfaces.dummy key=key item=sensor}

    <tr bgcolor="#cccccc">
		<td>{$sensor.interface_name}</td>     
		<td>{$sensor.interface_temperature.stat_value|string_format:"%.2f"}&deg;C</td>
	</tr>
	{foreachelse}
      <tr bgcolor="#cccccc">
        <td colspan="2">Brak danych</td>
      </tr>
	{/foreach}
</table>
