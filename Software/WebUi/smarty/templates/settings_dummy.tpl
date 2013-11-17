<div id="dashboard_dummy" style="display: none">
	<h3>Czujniki statyczne:</h3>
	<table>
		{foreach from=$interfaces.dummy key=key item=dummy}
		<tr>
			<td>
				Nazwa:
			</td>
			<td>
				<input class="long" name="dummies[{$dummy.interface_id}][dummy_name]" value="{$dummy.interface_name}"
					    onmouseover="return overlib('Podaj nową nazwę gpio. Minimum 2 znaki.');"
					    onmouseout="return nd();">
			</td>
			<td>
				&nbsp;Wartość:
			</td>
			<td>
				<input class="short" name="dummies[{$dummy.interface_id}][dummy_conf]" value="{$dummy.interface_conf}"
					    onmouseover="return overlib('Podaj nowy adres gpio. Minimum 2 znaki.');"
					    onmouseout="return nd();">
				
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
			<td>
				<input type="hidden" name="dummies[{$new_interface_id}][dummy_address]" value="{$dummy.interface_addressshortnext}">
				<input class="short" name="dummies[{$new_interface_id}][dummy_conf]" value=""
					    onmouseover="return overlib('Podaj wartość którą będzie raportował czujnik. Minimum 2 znaki.');"
					    onmouseout="return nd();">
				
			</td>
		</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>	
