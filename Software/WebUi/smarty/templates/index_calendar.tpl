<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czas</th><th>Opis</th><th></th></tr>
{foreach from=$events item="event"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td class="{if $event.days lt 1}red bold blink{elseif $event.days lt 3}red{elseif $event.days lt 5}red2{elseif $event.days lt 7}red3{/if}" style="width:1%">{$event.start_ts|date_format:"%e.%m.%y&nbsp;%H:%M"} ({$event.days} dni)</td>
		<td class="{if $event.days lt 1}red bold blink{elseif $event.days lt 3}red{elseif $event.days lt 5}red2{elseif $event.days lt 7}red3{/if}">{$event.subject}</td>
		<td><a href="plugins/calendar/calendar_task.php?oid={$event.oid}&is_sure=1" ><img 
			onmouseover="return overlib('Oznacz zadanie jako wykonane i usuń z listy.');"
			onmouseout="return nd();"
			src="img/undone.png"></a>
		</td>
    </tr>
    {foreachelse}
      <tr bgcolor="#cccccc">
        <td colspan="4">Brak wydarzeń</td>
      </tr>
{/foreach}
</table>
