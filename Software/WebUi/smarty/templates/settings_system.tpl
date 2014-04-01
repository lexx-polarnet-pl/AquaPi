<div id="dashboard_system" style="display: none">
<h3>Sensory systemowe:</h3>
	{if $interfaces.system}
	<table>
	<tr>
		<td colspan="3"></td>
		<td><img src="img/chart_thumb.png" onmouseover="return overlib('Pokazuj czujnik na wykresie.');" onmouseout="return nd();"></td>
		<td><img src="img/off_thumb.png"   onmouseover="return overlib('Wyłączenie czujnika. Zaznacz aby wyłączyć.');" onmouseout="return nd();"></td>
		<td></td>
	</tr>
	{foreach from=$interfaces.system key=key item=system}
	<tr>
	    <td>
		<input class="medium" {if $system.interface_disabled eq 1}style="color:grey" readonly="readonly"{/if} name="system[{$system.interface_id}][system_name]" value="{$system.interface_name}"
		    onmouseover="return overlib('Podaj nową nazwę czujnika. Minimum 2 znaki.');"
		    onmouseout="return nd();"><span style="font-size:xx-small;">(id:{$system.interface_id})</span>
	    </td>
	    <td>
		<input class="long" {if $system.interface_disabled eq 1}style="color:grey" readonly="readonly"{/if} type="text" name="system[{$system.interface_id}][system_address]" id="system[{$system.interface_id}][system_address]"
		    value="{$system.interface_address}"
		    onmouseover="return overlib('Wprowadź ręcznie adres czujnika');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<select class="short" name="system[{$system.interface_id}][system_unit]"
			onmouseover="return overlib('Wybierz jednostkę.');"
			onmouseout="return nd();">
			<option value="none">Brak</option>
			{foreach from=$units item=unit}
			    <option {if $system.interface_unit.unit_id eq $unit.unit_id}selected="selected"{/if} value="{$unit.unit_id}">{$unit.unit_name}</option>
			{/foreach}
		</select>
	    </td>
	    <td>
		<input type="checkbox" name="system[{$system.interface_id}][system_draw]" value="1" {if $system.interface_draw eq 1}checked="checked"{/if}
				{if $system.interface_disabled eq 1}onclick="return false" onmouseover="return overlib('Czujnik wyłaczony. Aktywuj go najpierw.');"
				onmouseout="return nd();"{else}
				onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
				onmouseout="return nd();"{/if}>
	    </td>
	    <td>
		<input type="checkbox" name="system[{$system.interface_id}][system_disabled]" value="1" {if $system.interface_disabled eq 1}checked="checked"
				onmouseover="return overlib('Czujnik wyłączony. Odznacz aby aktywować.');"
				onmouseout="return nd();"
				{else}
				onmouseover="return overlib('Czujnik aktywny. Zaznacz aby wyłączyć.');"
				onmouseout="return nd();"
				{/if}>
	    </td>

	    <td>
		<a href="?action=delete&interface_id={$system.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"
		    onmouseover="return overlib('Usunięcie czujnika');"
		    onmouseout="return nd();">
		    <img align="right" src="img/off.png"></a>
	    </td>
	</tr>
	{/foreach}
	<tr>
	    <td>
		<input class="medium" name="system[{$new_interface_id}][system_name]" value=""
		    onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 znaki.');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<input class="long" type="text" name="system[{$new_interface_id}][system_address]" id="system[{$new_interface_id}][system_address]"
		    value="" onmouseover="return overlib('Wprowadź ręcznie adres nowego czujnika');"
		    onmouseout="return nd();">
	    </td>
	    <td>
		<select class="short" name="system[{$new_interface_id}][system_unit]"
			onmouseover="return overlib('Wybierz jednostkę.');"
			onmouseout="return nd();">
			<option value="none">Brak</option>
			{foreach from=$units item=unit}
			    <option value="{$unit.unit_id}">{$unit.unit_name}</option>
			{/foreach}
		</select>
	    </td>
	    <td colspan="3">
		<input type="checkbox" name="system[{$new_interface_id}][system_draw]" value="1" 
		    onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
		    onmouseout="return nd();"></td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	

