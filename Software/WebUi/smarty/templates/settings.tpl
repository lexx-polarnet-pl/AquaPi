{include "header.tpl"}

<a href="/index.php"><img src="/img/back.png" style="float:left"></a>
<h1>Ustawienia:</h1>

<table>
<tr><th>Klucz</th><th>Wartość</th><th></th></tr>

{foreach from=$settings item="entry"}
	<form action="settings.php" method="post">
    <tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$entry.key}<input type="hidden" name="key" value="{$entry.key}"></td>        
		<td><input name="value" value="{$entry.value}"></td>
		<td><input type="submit" value="Zapisz"></td>
    </tr>
	</form>
    {foreachelse}
      <tr>
        <td colspan="3">No records</td>
      </tr>
{/foreach}


</table>

{include "footer.tpl"}