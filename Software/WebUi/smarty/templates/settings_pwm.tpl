<div id="dashboard_pwm" style="display: none">
	<h3>PWM:</h3>
	{if $interfaces.pwm}
	<table>
		<tr>
			<td colspan="7"></td>
			<td></td>
		</tr>
		{foreach from=$interfaces.pwm key=key item=pwm}
		<tr>
			<td>
				Nazwa:
			</td>
			<td>
				<input class="long" name="pwms[{$pwm.interface_id}][pwm_name]" value="{$pwm.interface_name}"
					    onmouseover="return overlib('Podaj nową nazwę pwm. Minimum 2 znaki.');"
					    onmouseout="return nd();"><span style="font-size:xx-small;">(id:{$pwm.interface_id})</span>
			</td>
			<td>
				&nbsp;Pin:
			</td>
			<td>
				<input class="short" name="pwms[{$pwm.interface_id}][pwm_address]" value="{$pwm.interface_address}"
					    onmouseover="return overlib('Podaj nowy adres pwm. Minimum 2 znaki.');"
					    onmouseout="return nd();">
			</td>
			<td style="width: 75px; text-align: right;">
				{if $pwm.interface_icon}<img src="img/{$pwm.interface_icon}">{/if}
			</td>
			<td>
				<select class="medium" name="pwms[{$pwm.interface_id}][pwm_icon]"
					onmouseover="return overlib('Wybierz ikonę dla wyjścia.');"
					onmouseout="return nd();">
					<option class="imagebacked" style="background-image:url(img/device.png);" {if $pwm.interface_icon eq "device.png"}selected{/if}>device.png</option>
					{foreach $icons item=icon}
					<option class="imagebacked" style="background-image:url(img/{$icon});" {if $pwm.interface_icon eq $icon}selected{/if}>{$icon}</option>
					{/foreach}
				</select> 
			</td>
			<td>
<!--				<input type="checkbox" name="pwms[{$pwm.interface_id}][sensor_draw]" value="1" {if $pwm.interface_draw eq 1}checked="checked"{/if}
					{if $pwm.interface_disabled eq 1}onclick="return false" onmouseover="return overlib('Przekaźnik wyłaczony. Aktywuj go najpierw.');"
					onmouseout="return nd();"{else}
					onmouseover="return overlib('Pokazuj przekaźnik na wykresie.');"
					onmouseout="return nd();"{/if}>-->
			</td>
			<td>
				<a href="?action=delete&interface_id={$pwm.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten czujnik?');"
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
			<input class="long" name="pwms[{$new_interface_id}][pwm_name]" value=""
					onmouseover="return overlib('Podaj nazwę nowego gpio. Minimum 2 znaki.');"
					onmouseout="return nd();">
		    </td>
		    <td>
			&nbsp;Pin:
		    </td>
		    <td colspan="2">
			<input class="short" name="pwms[{$new_interface_id}][pwm_address]" value=""
					onmouseover="return overlib('Podaj adres nowego gpio. Minimum 2 znaki.');"
					onmouseout="return nd();">
		    </td>
		</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
	{else}
		<div class="red">Urządzenie wyłączone.</div>
	{/if}
</div>	
