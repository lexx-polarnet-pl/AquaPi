{include "header.tpl"}

<div class="current">
<img src ="/img/babelfish.png" style="float:left;">
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
{*
<a href="outputs.php">
<div class="icon">
<img src="/img/Gnome-Dialog-Information-64.png">
Oświetlenie
</div>
</a>
*}
<a href="timers.php">
<div class="icon">
<img src="/img/preferences-system-time.png">
Timery
</div>
</a>

<a href="settings.php">
<div class="icon">
<img src="/img/advancedsettings.png">
Ustawienia sterownika
</div>
</a>

<a href="logs.php">
<div class="icon">
<img src="/img/Gnome-Utilities-System-Monitor-64.png">
Zdarzenia systemowe
</div>
</a>

<a href="stat.php">
<div class="icon">
<img src="/img/stat.png">
Statystyka sterownika
</div>
</a>

{include "footer.tpl"}