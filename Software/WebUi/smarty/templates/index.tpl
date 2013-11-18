{include "header.tpl"}

<div id="dashboard">
    <h3>Wyjścia & sensory:</h3>
    <div style="width:49%; float:left;">
    {include "index_gpio.tpl"}
    </div>
    <div style="width:49%; float:left;">
    {include "index_1wire.tpl"}
    </div>
</div>

<div id="dashboard">
<img src ="img/welcome_logo.png" style="float:left;">
<h3>Informacje o sterowniku:</h3>
<table>
<tr><td>Czas</td><td>{$time}</td></tr>
<tr><td>Temperatura zbiornika:</td><td>{$sensor_master_temp|string_format:"%.2f"}&deg;C</td></tr>
<tr><td>Uruchomiony:</td><td>{$enabled}</td></tr>
<tr><td>Wersja jądra:</td><td>{$uname_r}</td></tr>
<tr><td>Kompilacja:</td><td>{$uname_v}</td></tr>
<tr><td>Obciążenie:</td><td>{$load.0} {$load.1} {$load.2}</td></tr>
<tr><td>Temperatura CPU:</td><td>{$cputemp|string_format:"%.2f"}&deg;C</td></tr>
<tr><td>Wersja AquaPi:</td><td>{$aquapi_ver}</td></tr>
</table>
</div>

<div id="dashboard">
    <h3>Wyjścia & sensory:</h3>
    <div style="width:49%; float:left;">
    {include "index_relayboard.tpl"}
    </div>
    <div style="width:49%; float:left;">
    {include "index_dummy.tpl"}
    </div>
</div>


<div id="dashboard">
<h3>Komunikaty informacyjne z ostatnich 48h:</h3>
{include "index_logtable.tpl" logs = $last5infologs}
</div>
</div>

<div id="dashboard">
<h3>Komunikaty błędów z ostatnich 48h:</h3>
{include "index_logtable.tpl" logs = $last5warnlogs}
</div>

{include "footer.tpl"}