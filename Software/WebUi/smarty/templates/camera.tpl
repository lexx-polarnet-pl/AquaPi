{include "header.tpl"}

<div id="dashboard" style="text-align: center;">
    {if $message eq ""}
    <img src="modules/shot.php?action=photo&rot=180">
        <!--&w=512&h=320-->
    {else}
        {$message}
    {/if}
</div>
{include "footer.tpl"}