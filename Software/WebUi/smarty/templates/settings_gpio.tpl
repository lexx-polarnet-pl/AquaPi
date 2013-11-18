<div id="dashboard_gpio" style="display: none">
<h3>GPIO przyjazne nazwy wyjść:</h3>
<table>
	{foreach from=$interfaces.gpio key=key item=gpio}
	<tr>
	    <td>
		Nazwa:
	    </td>
	    <td>
		<input class="long" name="gpios[{$gpio.interface_id}][gpio_name]" value="{$gpio.interface_name}"
				onmouseover="return overlib('Podaj nową nazwę gpio. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		&nbsp;Pin:
	    </td>
	    <td>
		<input class="medium" name="gpios[{$gpio.interface_id}][gpio_address]" value="{$gpio.interface_address}"
				onmouseover="return overlib('Podaj nowy adres gpio. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		<select class="medium"
			onmouseover="return overlib('Wybierz ikonę dla wyjścia.');"
			onmouseout="return nd();">
			<option class="imagebacked" style="background-image:url(img/device.png);">&nbsp;device.png</option>
			{foreach $icons item=icon}
			<option class="imagebacked" style="background-image:url(img/{$icon});">&nbsp;{$icon}</option>
			{/foreach}
		</select> 
	    </td>
	</tr>
	{/foreach}
	<tr>
	    <td>
		Nazwa:
	    </td>
	    <td>
		<input class="long" name="gpios[{$new_interface_id}][gpio_name]" value=""
				onmouseover="return overlib('Podaj nazwę nowego gpio. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		&nbsp;Pin:
	    </td>
	    <td>
		<input class="medium" name="gpios[{$new_interface_id}][gpio_address]" value=""
				onmouseover="return overlib('Podaj adres nowego gpio. Minimum 2 znaki.');"
				onmouseout="return nd();">
	    </td>
	    <td>
		
	    </td>
	</tr>
	</table>
	<INPUT TYPE="image" SRC="img/submit.png" align="right">
</div>	
