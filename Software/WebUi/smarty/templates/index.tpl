{include "header.tpl"}

<div id="dashboard">
<img src ="/img/welcome_logo.png" style="float:left;">
<h3>Informacje o sterowniku:</h3>
Czas <span id="time">{$time}</span><br/>
Temperatura: <span id="temp">{$temp}&deg;C</span>
{if $heating} 
<img src="/img/heater_on.png" title="Grzałka włączona">
{else}
<img src="/img/heater_off.png" title="Grzałka wyłączona">
{/if}
{if $cooling} 
<img src="/img/cooling_on.png" title="Chłodzenie włączone">
{else}
<img src="/img/cooling_off.png" title="Chłodzenie wyłączone">
{/if}
<br/>
Aktualny scenariusz: 
{if $day}
dzień <img src="/img/day_s.png">
{else}
noc <img src="/img/night_s.png">
{/if}
<br/><br/>
</div>

<div id="dashboard">
<h3>Ostatnie 5 komunikatów informacyjnych:</h3>
{include "log_table.tpl" logs = $last5infologs}
</div>
</div>

<div id="dashboard">
<h3>Informacje o systemie:</h3>
<table>
<tr><td>Uruchomiony:</td><td>{$enabled}</td></tr>
<tr><td>Wersja jądra:</td><td>{$uname_r}</td></tr>
<tr><td>Kompilacja:</td><td>{$uname_v}</td></tr>
<tr><td>Obciążenie:</td><td>{$load.0} {$load.1} {$load.2}</td></tr>
<tr><td>Wersja AquaPi:</td><td>{$aquapi_ver}</td></tr>
</table>
</div>

<div id="dashboard">
<h3>Ostatnie 5 komunikatów błędów:</h3>
{include "log_table.tpl" logs = $last5warnlogs}
</div>
{include "footer.tpl"}