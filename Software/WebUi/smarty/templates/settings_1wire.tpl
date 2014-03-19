<div id="dashboard_1wire" style="display: none">
<h3>Ustawienia sensorów temperatury:</h3>
	{if $interfaces.1wire}
	<table>
	{foreach from=$interfaces.1wire key=key item=sensor}
	<tr>
	    <td>
		<input class="long" {if $sensor.interface_disabled eq 1}style="color:grey"{/if} name="sensors[{$sensor.interface_id}][sensor_name]" value="{$sensor.interface_name}"
				onmouseover="return overlib('Podaj nową nazwę czujnika. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<!--if $CONFIG.daemon.location == 'local'-->
			<select name="sensors[{$sensor.interface_id}][sensor_address]" id="sensors[{$sensor.interface_id}][sensor_address]" {if $sensor.interface_disabled eq 1}style="color:grey"{/if}
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();">
			    <option value="none">Brak</option>
			    {foreach from=$sensors_fs item="sensor_address"}
				<option {if $sensor_address eq $sensor.interface_addressshort}selected="selected"{/if}>{$sensor_address}</option>
			    {/foreach}
			</select>
		<!--else-->
		<!--	<input class="medium" {if $sensor.interface_disabled eq 1}style="color:grey"{/if} type="text" name="sensors[{$sensor.interface_id}][sensor_address]" id="sensors[{$sensor.interface_id}][sensor_address]"-->
		<!--		value="{$sensor.interface_addressshort}"-->
		<!--		onmouseover="return overlib('Wprowadź ręcznie adres czujnika');"-->
		<!--		onmouseout="return nd();">-->
		<!--/if-->
	        korekta:&nbsp;<input class="temp_select" {if $sensor.interface_disabled eq 1}style="color:grey"{/if} type="text" id="sensors[{$sensor.interface_id}][sensor_corr]" name="sensors[{$sensor.interface_id}][sensor_corr]" value ="{$sensor.interface_corr}"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
	    </td>
	    <td><input type="checkbox" name="sensors[{$sensor.interface_id}][sensor_draw]" value="1" {if $sensor.interface_draw eq 1}checked="checked"{/if}
				onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
				onmouseout="return nd();"></td>
	    <td><input type="checkbox" name="sensors[{$sensor.interface_id}][sensor_conf]" value="1" {if $sensor.interface_conf eq 1}checked="checked"{/if}
				onmouseover="return overlib('Czujnik główny, wyświetla się na stronie głównej. Zaznacz tylko jeden!');"
				onmouseout="return nd();"></td>
	    <td><input type="checkbox" name="sensors[{$sensor.interface_id}][sensor_disabled]" value="1" {if $sensor.interface_disabled eq 1}checked="checked"{/if}
				onmouseover="return overlib('Czujnik wyłączony.');"
				onmouseout="return nd();"></td>

	    <td><a href="?action=delete&interface_id={$sensor.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"
		onmouseover="return overlib('Usunięcie czujnika');"
				onmouseout="return nd();">
		<img align="right" src="img/off.png"></a>
	    </td>
	</tr>
	{/foreach}
	<tr>
	    <td>
		<input class="long" name="sensors[{$new_interface_id}][sensor_name]" value=""
				onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<!--if $CONFIG.daemon.location == 'local'-->
		<select name="sensors[{$new_interface_id}][sensor_address]" id="sensors[{$new_interface_id}][sensor_address]"
				onmouseover="return overlib('Wybierz czujnik.');"
				onmouseout="return nd();">
			<option value="">Brak</option>
			{foreach from=$sensors_fs item="sensor_address"}
			<option>{$sensor_address}</option>
			{/foreach}
		</select>
		<!--else-->
		<!--	<input class="medium" type="text" name="sensors[{$new_interface_id}][sensor_address]" id="sensors[{$new_interface_id}][sensor_address]"-->
		<!--		value=""-->
		<!--		onmouseover="return overlib('Wprowadź ręcznie adres nowego czujnika');"-->
		<!--		onmouseout="return nd();">-->
		<!---->
		<!--/if-->
	        korekta:&nbsp;<input class="temp_select" type="text" id="sensors[{$new_interface_id}][sensor_corr]"
				name="sensors[{$new_interface_id}][sensor_corr]" value ="0"
				onmouseover="return overlib('O ile skorygować odczytaną temperaturę. Przykładowe wartości:<br>0.4, -1.3, 4, -0.1 ...');"
				onmouseout="return nd();">
	    </td>
	    <td><input type="checkbox" name="sensors[{$new_interface_id}][sensor_draw]" value="1" 
				onmouseover="return overlib('Pokazuj czujnik na wykresie.');"
				onmouseout="return nd();"></td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	

