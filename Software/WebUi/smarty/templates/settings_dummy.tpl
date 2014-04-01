<div id="dashboard_dummy" style="display: none">
	<h3>Czujniki statyczne:</h3>
	{if $interfaces.dummy}
	<table>
		{foreach from=$interfaces.dummy key=key item=dummy}
		<tr>
			<td>
				Nazwa:
			</td>
			<td>
				<input class="long" name="dummies[{$dummy.interface_id}][dummy_name]" value="{$dummy.interface_name}"
					    onmouseover="return overlib('Podaj nową nazwę gpio. Minimum 2 znaki.');"
					    onmouseout="return nd();"><span style="font-size:xx-small;">(id:{$dummy.interface_id})</span>
			</td>
			<td>
				&nbsp;Wartość:
			</td>
			<td>
				<input class="short" name="dummies[{$dummy.interface_id}][dummy_conf]" value="{$dummy.interface_conf}"
					    onmouseover="return overlib('Podaj nowy adres gpio. Minimum 2 znaki.');"
					    onmouseout="return nd();">
				
			</td>
			<td>
				<select class="short" name="dummies[{$dummy.interface_id}][dummy_unit]"
					onmouseover="return overlib('Wybierz jednostkę.');"
					onmouseout="return nd();">
					<option value="none">Brak</option>
					{foreach from=$units item=unit}
					    <option {if $dummy.interface_unit.unit_id eq $unit.unit_id}selected="selected"{/if} value="{$unit.unit_id}">{$unit.unit_name}</option>
					{/foreach}
				</select>
			</td>
			<td><a href="?action=delete&interface_id={$dummy.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"
				onmouseover="return overlib('Usunięcie czujnika');"
						onmouseout="return nd();">
				<img align="right" src="img/off.png"></a>
			</td>
		</tr>
		{/foreach}
		<tr>
			<td>
				Nazwa:
			</td>
			<td>
				<input class="long" name="dummies[{$new_interface_id}][dummy_name]" value=""
					    onmouseover="return overlib('Podaj nazwę nowego czujnika. Minimum 2 znaki.');"
					    onmouseout="return nd();">
			</td>
			<td>
				&nbsp;Wartość:
			</td>
			<td >
				<input type="hidden" name="dummies[{$new_interface_id}][dummy_address]" value="{$dummy.interface_addressshortnext}">
				<input class="short" name="dummies[{$new_interface_id}][dummy_conf]" value=""
					    onmouseover="return overlib('Podaj wartość którą będzie raportował czujnik. Minimum 2 znaki.');"
					    onmouseout="return nd();">
				
			</td>
			<td>
				<select class="short" name="dummies[{$new_interface_id}][dummy_unit]"
					onmouseover="return overlib('Wybierz jednostkę.');"
					onmouseout="return nd();">
					<option value="none">Brak</option>
					{foreach from=$units item=unit}
					    <option value="{$unit.unit_id}">{$unit.unit_name}</option>
					{/foreach}
				</select>
			</td>
		</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	
