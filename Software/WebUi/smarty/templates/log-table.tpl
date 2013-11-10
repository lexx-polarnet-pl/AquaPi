<table style="width:100%">
<tr><th>Czas</th><th></th><th>Opis</th></tr>
{foreach from=$logs item="entry"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td style="width:1%">{$entry.time|date_format:"%e.%m.%y&nbsp;%H:%M:%S"}</td>        
		<td style="width:1%">
			{if $entry.level == 0}
				<img src="img/notice.png">
			{elseif $entry.level == 1}
				<img src="img/alert.png">
			{elseif $entry.level == 2}
				<img src="img/critical.png">
			{else}
				{$entry.level}
			{/if}
		</td>        
		<td>{$entry.message}</td>
    </tr>
    {foreachelse}
      <tr bgcolor="#cccccc">
        <td colspan="3">brak wpisów</td>
      </tr>
{/foreach}
</table>
