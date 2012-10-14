{include "header.tpl"}

<a href="/index.php"><img src="/img/back.png" style="float:left"></a>
<h1>Logi:</h1>

<table>
<tr><th>Czas</th><th>Poziom</th><th>Opis</th></tr>

{foreach from=$logs item="entry"}
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$entry.time|date_format:"%e %b, %Y %H:%M:%S"}</td>        
		<td>
			{if $entry.level == 0}
				<img src="/img/notice.png">
			{elseif $entry.level == 1}
				<img src="/img/alert.png">
			{elseif $entry.level == 2}
				<img src="/img/critical.png">
			{else}
				{$entry.level}
			{/if}
		</td>        
		<td>{$entry.message}</td>
    </tr>
    {foreachelse}
      <tr>
        <td colspan="3">No records</td>
      </tr>
{/foreach}


</table>

{include "footer.tpl"}