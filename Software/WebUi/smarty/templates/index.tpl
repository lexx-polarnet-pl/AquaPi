{include "header.tpl"}

<div class="current">
<img src ="/img/welcome_logo.png" style="float:left;">
Aktualne wartości:<br/>
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

{include "footer.tpl"}