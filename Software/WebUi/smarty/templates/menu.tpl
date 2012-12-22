<div id="menu">
{foreach from=$my_menu item=pos}
{if $pos.selected==true}
<div id="icon_select">
{else}
<div id="icon">
{/if}
<a href="{$pos.url}">
<img src="/img/{$pos.icon}" title="{$pos.name}">
</a>
</div>
{/foreach}
</div>