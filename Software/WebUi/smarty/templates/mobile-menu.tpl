<div id="menu">
{foreach from=$my_menu item=pos}
{if $pos.selected==true}
<div id="mb_icon_select">
{else}
<div id="mb_icon"> 
{/if}
<a href="{$pos.url}">
{$pos.name|truncate:3:""}
</a>
</div>
{/foreach}
</div>