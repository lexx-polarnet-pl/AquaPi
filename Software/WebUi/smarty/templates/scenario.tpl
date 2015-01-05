{include "header.tpl"}

<div style='background-color: rgb(220,220,220); margin:5px;'>
<div id ='clock' class='modern_box b1x1' draggable='true' ondragstart='drag(event)' style='background-color: rgb(200,200,0); background-image: url(img/icons/appbar.clock.png);'>
Zegar systemowy
</div>
<div id ='days' class='modern_box b1x1' draggable='true' ondragstart='drag(event)' style='background-color: rgb(200,200,0);  background-image: url(img/icons/appbar.calendar.week.png);'>
Dni tygodnia
</div>

{foreach from=$interfaces item="interface"}
	<div id ='{$interface.interface_id}'  class='modern_box b1x1' draggable='true' ondragstart='drag(event)' style='background-color: {if $interface.interface_type eq 1}rgb(100,255,100){elseif $interface.interface_type eq 2}rgb(100,100,255){else}rgb(255,100,100){/if}; background-image: url(img/icons/{$interface.interface_icon});'>
	{$interface.interface_name}
	</div>
{/foreach}
<span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Paleta</span>
</div>
<script>
var Tablica = [];
{foreach from=$interfaces item="interface"}
	Tablica[{$interface.interface_id}] = {$interface.interface_type};
{/foreach}
function allowDropOut(ev) {
	var data = ev.dataTransfer.getData("text");
	if ((Tablica[data]) == 2) {
		ev.preventDefault();
	}
}

function allowDropIn(ev) {
	ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
	//alert(Tablica[data])
	if ((Tablica[data]) == 2) {
		ev.target.innerHTML = document.getElementById(data).innerHTML + document.getElementById("template_selector_on_off").innerHTML;
		ev.target.style.backgroundColor = document.getElementById(data).style.backgroundColor;
		ev.target.style.backgroundImage = document.getElementById(data).style.backgroundImage;
	}

	// zapisz ID wejścia w formularzu żeby potem można było go wykorzystać
	var RefId = document.createElement("input");
	RefId.name = "SourceID";
	RefId.value = data;
	RefId.type = "hidden";
	ev.target.appendChild(RefId)
	
	// Dla wszystkich elementów formularza jeśli mają name dopisz output żeby wiedzieć czego dotyczy
	var eleChild = ev.target.childNodes;
	for( i = 0 , j = eleChild.length; i < j ; i++ ){
		if (eleChild[i].name) {
			eleChild[i].name = "output_" + eleChild[i].name;
		}
	}
}

function dropin(ev) {
    ev.preventDefault();
	// w zmiennej data będzie teraz ID wejścia
    var data = ev.dataTransfer.getData("text");

    // dodaj elementy formularza zawarte we "wzorcach"
	if  ((Tablica[data]) == 2) {
		ev.target.innerHTML = document.getElementById(data).innerHTML + document.getElementById("template_selector_on_off").innerHTML;
	} else if (data == "clock") {
		ev.target.innerHTML = document.getElementById(data).innerHTML + document.getElementById("template_selector_time").innerHTML;
	} else if (data == "days") {
		ev.target.innerHTML = document.getElementById(data).innerHTML + document.getElementById("template_selector_days").innerHTML;
	} else {
		ev.target.innerHTML = document.getElementById(data).innerHTML + document.getElementById("template_selector_default_input").innerHTML;
	}

	// skopiuj kolor i obraz tła ze źródła
	ev.target.style.backgroundColor = document.getElementById(data).style.backgroundColor;
	ev.target.style.backgroundImage = document.getElementById(data).style.backgroundImage;

	// zapisz ID wejścia w formularzu żeby potem można było go wykorzystać
	var RefId = document.createElement("input");
	RefId.name = "SourceID";
	RefId.value = data;
	RefId.type = "hidden";
	ev.target.appendChild(RefId)
	
	// Dla wszystkich elementów formularza jeśli mają name dopisz id tego diva żeby umożliwić duplikaty
	var eleChild = ev.target.childNodes;
	for( i = 0 , j = eleChild.length; i < j ; i++ ){
		if (eleChild[i].name) {
			eleChild[i].name = ev.target.id + "_" + eleChild[i].name;
		}
	}
	
	var new_id = 'input_' + String(parseInt(ev.target.id.substring(6).valueOf())+1 );
	// dodaj nowy pusty box
	if (!document.getElementById(new_id)) {
		var newDiv = document.createElement("div");
		newDiv.innerHTML = "Przeciągnij tutaj...";
		newDiv.id = new_id;
		newDiv.setAttribute("ondrop","dropin(event)");
		newDiv.setAttribute("ondragover","allowDropIn(event)");
		newDiv.className = "modern_box b2x1";
		document.getElementById("inputs").appendChild(newDiv);
	}	
}
</script>
<form action="scenarios.php" method="post">
<input name = "ScenarioID" value = "{$id}" type = "hidden">
<input name = "ScenarioName">
	
<div id="inputs" style='background-color: rgb(220,220,220); margin:5px; '><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Sygnały wejściowe</span><div 
id="input_1" ondrop="dropin(event)" ondragover="allowDropIn(event)" class='modern_box b2x1'>Przeciągnij tutaj...</div></div>
<div id="logical" style='background-color: rgb(220,220,220); margin:5px;'><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Funkcja łącząca</span>
<input type="radio" name="scenario_logic" value="AND" checked>AND
<input type="radio" name="scenario_logic" value="OR">OR
<input type="radio" name="scenario_logic" value="NOT">NOT
<input type="radio" name="scenario_logic" value="XOR">XOR
</div>
<div id="outputs" style='background-color: rgb(220,220,220); margin:5px;'><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Wyjście</span>
<div id="output" ondrop="drop(event)" ondragover="allowDropOut(event)" class='modern_box b2x1'>Przeciągnij tutaj...</div>
</div>
<input type="submit" value="Submit">
</form>

<span style="visibility: hidden;">
<div class='modern_box b2x1'>Tester selektora
<div id="template_selector_on_off">
	<select name="value" style='width:100%'>
		<option value='0'>Wyłączone</option>
		<option value='1'>Załączone</option>
	</select>
</div>
</div>
<div class='modern_box b2x1'>Tester selektora czasu
<div id="template_selector_time">
	<select name="direction" style='width:40px'>
		<option value='&lt;'>&lt;</option>
		<option value='&gt;'>&gt;</option>
	</select> 
	<input name = "hour" type='text' style='width:40px'>:
	<input name = "min"  type='text' style='width:40px'>:
	<input name = "sec"  type='text' style='width:40px'>
</div>
</div>
<div class='modern_box b2x1'>Tester selektora
<div id="template_selector_days">

		<input type='checkbox' name='pn' value='1' />Pn
		<input type='checkbox' name='wt' value='1' />Wt
		<input type='checkbox' name='sr' value='1' />Sr
		<input type='checkbox' name='cz' value='1' />Cz
		<input type='checkbox' name='pt' value='1' />Pt
		<input type='checkbox' name='so' value='1' />So
		<input type='checkbox' name='nd' value='1' />Nd

</div>
</div>
<div class='modern_box b2x1'>Tester selektora
<div id="template_selector_default_input">
	<select name="direction" style='width:40px'>
		<option value='&lt;'>&lt;</option>
		<option value='&gt;'>&gt;</option>
	</select> 
	<input name='value'></div>
</div>
</span>

{include "footer.tpl"}