<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czas</th><th>Opis</th></tr>
{foreach from=$events item="event"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td style="width:1%">{$event.start_ts|date_format:"%e.%m.%y&nbsp;%H:%M"}</td>        
		<td>{$event.subject}</td>
    </tr>
    {foreachelse}
      <tr bgcolor="#cccccc">
        <td colspan="3">Brak wydarzeń</td>
      </tr>
{/foreach}
</table>
