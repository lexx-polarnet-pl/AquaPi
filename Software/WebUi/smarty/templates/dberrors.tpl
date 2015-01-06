<div class="dberrors" id="dberrors" onclick="document.getElementById('dberrors').style.display = 'none';">
<span class="alert">Wystąpiły błędy w obsłudze bazy danych!</span><BR>
{foreach from=$dberrors item=dberror}
{if $layout.dbdebug}
	<span class="bold">({math equation="x*1000" x=$dberror.time format="%.4f"} ms):</span> {$dberror.query}<BR>
{else}
	<span class="bold">Query:</span> {$dberror.query}<BR>
	<span class="bold">Błąd:</span> {$dberror.error}<BR>
{/if}
{/foreach}
</div>