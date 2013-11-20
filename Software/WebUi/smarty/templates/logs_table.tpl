<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Czas</th><th></th><th>Opis</th></tr>
{foreach from=$logs item="entry"}
<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
                <td style="width:1%">{$entry.log_date|date_format:"%e.%m.%y&nbsp;%H:%M:%S"}</td>
                <td style="width:1%">
                        {if $entry.log_level == 0}
                                <img src="img/notice.png">
                        {elseif $entry.log_level == 1}
                                <img src="img/alert.png">
                        {elseif $entry.log_level == 2}
                                <img src="img/critical.png">
                        {else}
                                {$entry.log_level}
                        {/if}
                </td>
                <td>{$entry.log_value}</td>
</tr>
{foreachelse}
<tr bgcolor="#cccccc">
<td colspan="3">Brak wpisów</td>
</tr>
{/foreach}
</table>
