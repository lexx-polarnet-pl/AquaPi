{include "header.tpl"}

<!--<div id="dashboard">
    <h3>Wyjścia:</h3>
    <div style="float:left;">
        include "index_outputs.tpl"
    </div>
</div>-->

{include "index_aquainfo.tpl"}

{include "index_1wire.tpl"}

<div id="dashboard">
    <h3>Wyjścia:</h3>
    <div style="width:49%; float:left;">
        {include "index_gpio.tpl"}
    </div>
    <div style="width:49%; float:left;">
	{include "index_relayboard.tpl"}
    </div>
</div>

<div id="dashboard">
    <h3>Komunikaty informacyjne z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5infologs}
</div>

<div id="dashboard">
    <h3>Komunikaty błędów z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5warnlogs}
</div>

{include "footer.tpl"}