<div id="dashboard_system" style="display: none">
<h3>Sensory systemowe:</h3>
	{if $interfaces.system}
	<table>
	{foreach from=$interfaces.system key=key item=sensor}
	<tr>
	    <td>
		<input class="long" {if $sensor.interface_disabled eq 1}style="color:grey"{/if} name="system[{$sensor.interface_id}][sensor_name]" value="{$sensor.interface_name}"
		    onmouseover="return overlib('Podaj nową nazwę czujnika. Minimum 2 znaki.');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<input class="medium" {if $sensor.interface_disabled eq 1}style="color:grey"{/if} type="text" name="system[{$sensor.interface_id}][sensor_address]" id="sensors[{$sensor.interface_id}][sensor_address]"
		    value="{$sensor.interface_address}"
		    onmouseover="return overlib('Wprowadź ręcznie adres czujnika');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<input type="checkbox" name="system[{$sensor.interface_id}][sensor_draw]" value="1" {if $sensor.interface_draw eq 1}checked="checked"{/if}
		    onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<input type="checkbox" name="system[{$sensor.interface_id}][sensor_disabled]" value="1" {if $sensor.interface_disabled eq 1}checked="checked"{/if}
		    onmouseover="return overlib('Czujnik wyłączony.');"
		    onmouseout="return nd();">
	    </td>

	    <td>
		<a href="?action=delete&interface_id={$sensor.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"
		    onmouseover="return overlib('Usunięcie czujnika');"
		    onmouseout="return nd();">
		    <img align="right" src="img/off.png"></a>
	    </td>
	</tr>
	{/foreach}
	<tr>
	    <td>
		<input class="long" name="system[{$new_interface_id}][sensor_name]" value=""
		    onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 znaki.');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<input class="medium" type="text" name="system[{$new_interface_id}][sensor_address]" id="sensors[{$new_interface_id}][sensor_address]"
		    value="" onmouseover="return overlib('Wprowadź ręcznie adres nowego czujnika');"
		    onmouseout="return nd();">
	    </td>
	    <td colspan="3">
		<input type="checkbox" name="system[{$new_interface_id}][sensor_draw]" value="1" 
		    onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
		    onmouseout="return nd();"></td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	

