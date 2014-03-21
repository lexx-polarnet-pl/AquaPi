<table style="width:100%">
<tr bgcolor="#aaaaaa"><th>Wyjście</th><th>Stan</th></tr>
<!--foreach from=$interfaces.relayboard item="interface"
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$interface.interface_name}</td>     
		<td>
			{if $interface.interface_icon}
				<img src="img/{$interface.interface_icon}">
			{else}
				<img src="img/device.png">
			{/if}
			<img src="img/{if $interface.interface_state.stat_value == 1}on.png{else}off.png{/if}" style="position:relative; left:-15px">
		</td>
	</tr>
/foreach-->

{foreach from=$status.aquapi.devices.device item="device"}
	{if $device.type == 2 && strpos($device.address, "relbrd") !== false}
	<tr bgcolor="{cycle values="#cccccc,#dddddd"}">
		<td>{$device.name}</td>     
		<td>	
			<a href="#" class="topopup" onclick="SetMyPopup('{$device.name}','{if $device.state == -1}Nieokreślony{elseif $device.state == 1}Włączony{else}Wyłączony{/if}');">
				<div id="{if $device.state == -1}device{elseif $device.state == 1}device-on{else}device-off{/if}"
					title="{if $device.state == -1}Nieokreślony{elseif $device.state == 1}Włączony{else}Wyłączony{/if}">
					{if $icons[{$device.id}]}
							<img src="img/{$icons[{$device.id}]}">
					{else}
							<img src="img/device.png">
					{/if}
				</div>
			</a>
		</td>
	</tr>
	{/if}
{/foreach}
</table>


<div id="toPopup"> 
	<div class="close"></div>
	<span class="ecs_tooltip">Naciśnij ESC<span class="arrow"></span></span>
	<div id="popup_content"> <!--your content start-->
		<h3><span id="dev_name">Undefined</span></h3>
		<p>Stan: <span id="dev_state">Undefined</span><br/>
		Tryb: Automatyczny<br/></br>
		Zmień tryb:<br/>
		<a href="#" onclick="alert('Tu się kiedyś coś włączy')"><img src="img/device_on.png" title="Załącz w trybie ręcznym"></a>
		<a href="#" onclick="alert('A tu wyłączy')"><img src="img/device_off.png" title="Wyłącz w trybie ręcznym"></a>
		<a href="#" onclick="alert('A tu będzie auto...')"><img src="img/device_auto.png" title="Przejdź w tryb automatyczny"></a></p>			
	</div> 
</div>

<div class="loader"></div>
<div id="backgroundPopup"></div>