{include "header.tpl"}

Strona: 
{for $page=0 to $pages-1}
		<a href="/logs.php?&offset={$page}">{$page+1}</a>
{/for}

{include "logs_table.tpl"}

{include "footer.tpl"}