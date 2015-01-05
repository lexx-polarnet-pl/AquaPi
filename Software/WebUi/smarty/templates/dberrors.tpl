<div class="dberrors">
<span class="alert">Database errors occurred!</span><BR>
{foreach from=$dberrors item=dberror}
{if $layout.dbdebug}
	<span class="bold">({math equation="x*1000" x=$dberror.time format="%.4f"} ms):</span> {$dberror.query}<BR>
{else}
	<span class="bold">Query:</span> {$dberror.query}<BR>
	<span class="bold">Error:</span> {$dberror.error}<BR>
{/if}
{/foreach}
</div>