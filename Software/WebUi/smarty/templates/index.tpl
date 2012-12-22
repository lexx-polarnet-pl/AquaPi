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
ToDo!
</div>

<div id="dashboard">
<h3>Ostatnie 5 komunikatów błędów:</h3>
{include "log_table.tpl" logs = $last5warnlogs}
</div>
{include "footer.tpl"}