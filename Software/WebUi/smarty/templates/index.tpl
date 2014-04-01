{include "header.tpl"}

<!--<div id="dashboard">
    <h3>Wyjścia:</h3>
    <div style="float:left;">
        include "index_outputs.tpl"
    </div>
</div>-->

<!--Informacje o sterowniku-->
{include "index_aquainfo.tpl"}

<!--Sensory-->
{include "index_1wire.tpl"}

<!--Wyjścia-->
<div id="dashboard">
    <h3>Wyjścia:</h3>
    <div style="width:49%; float:left;">
        {include "index_gpio.tpl"}
    </div>
    <div style="width:49%; float:left;">
	{include "index_relayboard.tpl"}
    </div>
</div>

<!--Komunikaty informacyjne z ostatnich 48h-->
<div id="dashboard">
    <h3>Komunikaty informacyjne z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5infologs}
</div>

<!--Komunikaty błędów z ostatnich 48h-->
<div id="dashboard">
    <h3>Komunikaty błędów z ostatnich 48h:</h3>
    {include "index_logtable.tpl" logs = $last5warnlogs}
</div>




<div id="toPopup"> 
	<div class="close"></div>
	<span class="ecs_tooltip">Naciśnij ESC<span class="arrow"></span></span>
	<div id="popup_content"> <!--your content start-->
		<h3><span id="dev_name">Undefined</span></h3>
		<p>Stan: <span id="dev_state">Undefined</span><br/>
		Tryb: Automatyczny<br/></br>
		Zmień tryb:<br/>
		<a id="button_on"   href="#" onclick=""><img src="img/device_on.png" title="Załącz w trybie ręcznym"></a>
		<a id="button_off"  href="#" onclick=""><img src="img/device_off.png" title="Wyłącz w trybie ręcznym"></a>
		<a id="button_auto" href="#" onclick=""><img src="img/device_auto.png" title="Przejdź w tryb automatyczny"></a></p>			
	</div> 
</div>

<div class="loader"></div>
<div id="backgroundPopup"></div>

{include "footer.tpl"}