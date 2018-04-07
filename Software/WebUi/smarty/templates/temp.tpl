{include "header.tpl"}

<script type="text/javascript">

$(function() {

	$("#SLIDE_TMAX").slider({
		slide: function(event, ui) { 
				document.getElementById('TMAX').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.5,
		min: 15,
		max: 30,
		value: {$CONFIG.temp_tmax}
	});	
	
	$("#SLIDE_HC").slider({
		slide: function(event, ui) { 
				document.getElementById('HC').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.1,
		min: 0,
		max: 5,
		value: {$CONFIG.temp_hc}
	});	
	
	$("#SLIDE_TMIN").slider({
		slide: function(event, ui) { 
				document.getElementById('TMIN').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.5,
		min: 15,
		max: 30,
		value: {$CONFIG.temp_tmin}
	});	
	
	$("#SLIDE_HG").slider({
		slide: function(event, ui) { 
				document.getElementById('HG').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.1,
		min: 0,
		max: 5,
		value: {$CONFIG.temp_hg}
	});		
	$("#SLIDE_NCOR").slider({
		slide: function(event, ui) { 
				document.getElementById('NCOR').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.1,
		min: -5,
		max: 0,
		value: {$CONFIG.temp_ncor}
	});	
	$("#SLIDE_TMAXAL").slider({
		slide: function(event, ui) { 
				document.getElementById('TMAXAL').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.5,
		min: 15,
		max: 35,
		value: {$CONFIG.temp_tmaxal}
	});	
	$("#SLIDE_TMINAL").slider({
		slide: function(event, ui) { 
				document.getElementById('TMINAL').value = ui.value.toFixed(1) + "°C";
		},
		step: 0.5,
		min: 15,
		max: 35,
		value: {$CONFIG.temp_tminal}
	});		
});
</script>


<div id="dashboard">
<form action="temp.php" method="post">
<table>
<tr><td>Tmax</td><td><input type="text" readonly id="TMAX" name="TMAX" value ="{$CONFIG.temp_tmax}&deg;C"></td><td style="width:200px"><div id="SLIDE_TMAX"></div></td></tr>
<tr><td>Hc</td><td><input type="text" readonly id="HC" name="HC" value ="{$CONFIG.temp_hc}&deg;C"></td><td><div id="SLIDE_HC"></div></td></tr>
<tr><td>Tmin</td><td><input type="text" readonly id="TMIN" name="TMIN" value ="{$CONFIG.temp_tmin}&deg;C"></td><td><div id="SLIDE_TMIN"></div></td></tr>
<tr><td>Hg</td><td><input type="text" readonly id="HG" name="HG" value ="{$CONFIG.temp_hg}&deg;C"></td><td><div id="SLIDE_HG"></div></td></tr>
<tr><td>Ncor</td><td><input type="text" readonly id="NCOR" name="NCOR" value ="{$CONFIG.temp_ncor}&deg;C"></td><td><div id="SLIDE_NCOR"></div></td></tr>
<tr><td>Tmaxal</td><td><input type="text" readonly id="TMAXAL" name="TMAXAL" value ="{$CONFIG.temp_tmaxal}&deg;C"></td><td><div id="SLIDE_TMAXAL"></div></td></tr>
<tr><td>Tminal</td><td><input type="text" readonly id="TMINAL" name="TMINAL" value ="{$CONFIG.temp_tminal}&deg;C"></td><td><div id="SLIDE_TMINAL"></div></td></tr>
<tr><td>Grzałka</td><td colspan=2><select name="interface_heat">
{foreach from=$interfaces item="interface"}
	{if $interface.interface_type==2}
		<option value="{$interface.interface_id}"{if $interface.interface_id == $CONFIG.temp_interface_heat} selected{/if}>{$interface.interface_name}</option>
	{/if}
{/foreach}
</select></td></tr>
<tr><td>Chłodzenie</td><td colspan=2><select name="interface_cool">
{foreach from=$interfaces item="interface"}
	{if $interface.interface_type==2}
		<option value="{$interface.interface_id}"{if $interface.interface_id == $CONFIG.temp_interface_cool} selected{/if}>{$interface.interface_name}</option>
	{/if}
{/foreach}
</select></td></tr>
<tr><td>Czujnik temperaturty</td><td colspan=2><select name="interface_sensor">
{foreach from=$interfaces item="interface"}
	{if $interface.interface_type==1}
		<option value="{$interface.interface_id}"{if $interface.interface_id == $CONFIG.temp_interface_sensor} selected{/if}>{$interface.interface_name}</option>
	{/if}
{/foreach}
</select></td></tr>
</table>
<INPUT TYPE="image" SRC="img/submit.png" align="right">
</form>

</div>
<div id="dashboard">
<img src="img/temp.svg" align="right"></img>
</div>
<div id="dashboard">
Legenda:<br/>
<table>
<tr><td>Tzad</td><td>-</td><td>Temperatura zadana. To jest wartość wirtualna, tylko żeby się orientować w działaniu sterownika. Nie występuje w ustawieniach.</td></tr>
<tr><td>Tmax</td><td>-</td><td>Temperatura maksymalna. Przekroczenie tej temperatury powoduje załączenie chłodzenia.</td></tr>
<tr><td>Hc</td><td>-</td><td>Histereza chłodzenia. Chłodzenie będzie tak długo aktywne, aż aktualna temperatura spadnie poniżej poziomu Tmax - Hc.</td></tr>
<tr><td>Tmin</td><td>-</td><td>Temperatura minimalna. Zejście poniżej tej temperatury powoduje załączenie ogrzewania.</td></tr>
<tr><td>Hg</td><td>-</td><td>Histereza grzania. Grzanie będzie tak długo aktywne, aż aktualna temperatura wzrośnie powyżej poziomu Tmin + Hg.</td></tr>
<tr><td>Ncor</td><td>-</td><td>Korekta nocna. Ustawienie niezerowej wartości spowoduje że zostanie ona dodana do parametrów Tmax, Hc, Tmin, Hg. Przykładowo ustawienie -2&deg;C spowoduje że system będzie starał się utrzymywać temperaturę w nocy o 2&deg;C niższą niż w dzień.</td></tr>
<tr><td>Tmaxal</td><td>-</td><td>Wartość temperatury powyżej której system zacznie generować alarm.</td></tr>
<tr><td>Tminal</td><td>-</td><td>Wartość temperatury poniżej której system zacznie generować alarm.</td></tr>
</table>
</div>

{include "footer.tpl"}