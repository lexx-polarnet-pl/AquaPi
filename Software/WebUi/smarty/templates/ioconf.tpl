{include "header.tpl"}
<script>
function confirmLink(theLink, message)
{
	var is_confirmed = confirm(message);

	if (is_confirmed) {
		theLink.href += '&is_sure=1';
	}
	return is_confirmed;
}

</script>
        <div class="content mt-3">
            <div class="animated fadeIn">
				<form action="ioconf.php" method="post" class="form-horizontal">				
					<div class="row">
						<div class="col-lg-12">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Skonfigurowane urządzenia</strong>
                                </div>
                                <div class="card-body">
                                    <div class="default-tab">
                                        <nav>
                                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
											{foreach name=devs from=$devices item="device"}
                                                <a class="nav-item nav-link{if $smarty.foreach.devs.first} active{/if}" id="nav-contact-tab" data-toggle="tab" href="#nav-{$device.interface_id}" role="tab" aria-controls="nav-{$device.interface_id}" aria-selected="{if $smarty.foreach.devs.first}true{else}false{/if}"><img src="img/devices/{$device.interface_icon}"> {$device.interface_name}</a>
											{/foreach}	
                                            </div>
                                        </nav>
                                        <div class="tab-content pl-3 pt-2" id="nav-tabContent">
											{foreach name=devs from=$devices item="device"}
                                            <div class="tab-pane fade{if $smarty.foreach.devs.first} show active{/if}" id="nav-{$device.interface_id}" role="tabpanel" aria-labelledby="nav-{$device.interface_id}">
												<div class="row form-group">
													<div class="col-12">Urządzenie o adresie <b>{$device.interface_address}</b> pracuje jako <b>{if $device.interface_type==1}Wejście{elseif $device.interface_type==2}Wyjście binarne{elseif $device.interface_type==3}Wyjście PWM{/if}</b></div>
												</div>
												<div class="row form-group">
													<div class="col-2"><label for="InputFriendlyName" class=" form-control-label">Przyjazna nazwa</label></div>
													<div class="col-5"><input name="interfaces[{$device.interface_id}][name]" value="{$device.interface_name}" class="form-control"></input></div>
													{if $device.interface_type==2 || $device.interface_type==3}
													<div class="col-3"><label for="InputConf" class=" form-control-label">Zaneguj wyjście</label></div>
													<div class="col-2">
														<label class="switch switch-3d switch-secondary mr-3"><input type="checkbox" class="switch-input" {if $device.interface_conf eq 1}checked="true"{/if} name="interfaces[{$device.interface_id}][conf]"> <span class="switch-label"></span> <span class="switch-handle"></span></label>
													</div>
													{/if}
													{if $device.interface_type==1}
													<div class="col-3"><label for="uom" class=" form-control-label">Jednostka</label></div>
													<div class="col-2">
														<!-- <input type="checkbox" name="interfaces[{$device.interface_id}][conf]" class="form-check-input" {if $device.interface_conf eq 1} checked{/if}> -->
														
														<select name="interfaces[{$device.interface_id}][uom]" class="form-control">
															{foreach $uom item=uoms}
															<option value="{$uoms.unit_id}"{if $uoms.unit_id==$device.interface_uom} selected{/if}>{$uoms.unit_name}</option>
															{/foreach}
														</select>															
														
													</div>
													{/if}
												</div>
												<div class="row form-group">
													<div class="col-2"><label for="InputLocation" class=" form-control-label">Lokalizacja</label></div>
													<div class="col-5"><input name="interfaces[{$device.interface_id}][location]" value="{$device.interface_location}" class="form-control"></input></div>
												
													<div class="col-3"><label for="htmlcolor" class=" form-control-label">Kolor</label></div>
													<div class="col-1"><input type="color" value="#{$device.interface_htmlcolor}" name="interfaces[{$device.interface_id}][htmlcolor]" class="form-control"></div>	
												</div>													
												<div class="row form-group">
													<div class="col-2"><label for="InputIconSelector" class=" form-control-label">Ikona</label></div>
													<div class="col-5 input-group">
														<img src="img/devices/{$device.interface_icon}" id="icon-prev-{$device.interface_id}" class="mr-1"> 
														<select name="interfaces[{$device.interface_id}][img]" id="IconSelectorId{$device.interface_id}" class="form-control" onchange="document.getElementById('icon-prev-{$device.interface_id}').setAttribute('src','img/devices/' + document.getElementById('IconSelectorId{$device.interface_id}').value);">
															{foreach $icons item=icon}
															<option data-imagesrc="img/devices/{$icon}"{if $icon==$device.interface_icon} selected{/if}>{$icon}</option>
															{/foreach}
														</select>	
													</div>													
													<div class="col-3"><label for="InputConf" class=" form-control-label">Pokazuj na wykresach</label></div>
													<div class="col-2">
														<label class="switch switch-3d switch-primary mr-3"><input type="checkbox" class="switch-input" {if $device.interface_draw eq 1}checked="true"{/if} name="interfaces[{$device.interface_id}][draw]"> <span class="switch-label"></span> <span class="switch-handle"></span></label>
													</div>	
												</div>													
												<div class="row form-group">	
													{if $device.interface_type==2}
													<div class="col-4"><label for="InputFriendlyName" class=" form-control-label">W trybie serwisowym urządzenie ma zostać</label></div>
													<div class="col-3">
														<select name="interfaces[{$device.interface_id}][service_val]" class="form-control">
															<option value="-1"{if $device.interface_service_val == -1} selected{/if}>Bez znaczenia</option>														
															<option value="0"{if $device.interface_service_val == 0} selected{/if}>Wyłączone</option>
															<option value="1"{if $device.interface_service_val == 1} selected{/if}>Załączone</option>
														</select>
													</div>
													{elseif $device.interface_type==3}
													<div class="col-4"><label for="InputFriendlyName" class=" form-control-label">W trybie serwisowym ustaw PWM na</label></div>
													<div class="col-2">
														<input type="number" name="interfaces[{$device.interface_id}][service_val]" class="form-control" value="{$device.interface_service_val}" step=1 min=-1 max=100>
													</div>		
													<div class="col-1">
														%
													</div>
													{else}
													<div class="col-7">
													</div>
													{/if}
													<div class="col-3"><label for="InputConf" class=" form-control-label">Pokazuj na dasboard</label></div>
													<div class="col-2">
														<label class="switch switch-3d switch-primary mr-3"><input type="checkbox" class="switch-input" {if $device.interface_dashboard eq 1}checked="true"{/if} name="interfaces[{$device.interface_id}][dashboard]"> <span class="switch-label"></span> <span class="switch-handle"></span></label>
													</div>													
												</div>
												<div class="row form-group">
													<div class="col-12">
														<a href="?action=delete&device_id={$device.interface_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć to urządzenie?');" class="btn btn-danger btn-sm float-right">
															<i class="fa fa-times"></i> Usuń {$device.interface_name}
														</a>
													</div>
												</div>
                                            </div>
											{/foreach}	
                                        </div>

                                    </div>
                                </div>
								<div class="card-footer">
									<button type="submit" class="btn btn-primary btn-sm">
										<i class="fa fa-save"></i> Zapisz
									</button>
									<button type="reset" class="btn btn-danger btn-sm">
										<i class="fa fa-ban"></i> Reset
									</button>									
								</div>										
                            </div>
                        </div>
					</div>
				</form>	
			</div>
		</div>
			
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="ioconf.php?action=add" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Dodaj nowe wejście lub wyjście</strong>
                                </div>							
								<div class="card-body card-block">
<script>
function ChangeInput()
{
	var devices = new Array();
	{foreach from=$device_list->devicelist->device item="device"}
	devices.push(Array('{$device->address}','{$device->description}','{$device->fully_editable_address}', '{$device->prompt}', '{$device->input}', '{$device->output}', '{$device->pwm}'));
	{/foreach}

	var length = devices.length;
	var e = document.getElementById("InputAddressSelector").value;
	var FullyEditableVisible = false;
	
	for (var i = 0; i < length; i++)
	{
		var item = devices[i];
		if (item[0] == e) 
		{
			if (item[2] == 'yes') {
				document.getElementById('FullyEditable').disabled = false;
				document.getElementById('FullyEditablePrompt').innerHTML = item[3];
			} else 	{
				document.getElementById('FullyEditable').value = "";
				document.getElementById('FullyEditable').disabled = true;
			}
			if (item[4] == 'yes') {
				document.getElementById('IOIn').disabled = false;

			} else {
				document.getElementById('IOIn').disabled = true;
			}
			if (item[5] == 'yes') {
				document.getElementById('IOOut').disabled = false;				
			} else {
				document.getElementById('IOOut').disabled = true;
			}			
			if (item[6] == 'yes') {
				document.getElementById('IOOutPWM').disabled = false;				
			} else {
				document.getElementById('IOOutPWM').disabled = true;
			}				
			if (item[5] == 'yes' && item [4] == 'no') document.getElementById('IOOut').checked = true;
			if (item[4] == 'yes' && item [5] == 'no') document.getElementById('IOIn').checked = true;
		}
	}
}

function ChangeIcon()
{
	var icon = document.getElementById("InputIconSelector").value;
	document.getElementById("icon-prev").setAttribute("src","img/devices/" + icon);

}
window.onload = load;

function load()
{
	ChangeInput();
	ChangeIcon();
}
</script>

									<div class="row form-group">
										<div class="col-2"><label for="InputFriendlyName" class=" form-control-label">Przyjazna nazwa</label></div>
										<div class="col-4"><input type="text" id="InputFriendlyName" name="InputFriendlyName" class="form-control"></div>
										<div class="col-2"><label for="InputAddressSelector" class=" form-control-label">Adres sprzętowy</label></div>
										<div class="col-4">
											<select name="InputAddressSelector" id="InputAddressSelector" onchange="ChangeInput()" class="form-control">
											{foreach from=$device_list->devicelist->device item="device"}
												{if ($device->input == 'yes') && !($device->configured == 'yes')}
													<option value="{$device->address}">{$device->description}</option>
												{/if}
											{/foreach}
											</select>
										</div>
									</div>
									<div class="row form-group">
										<div class="col-2"><label for="FullyEditable" class=" form-control-label" id="FullyEditablePrompt">Dodatkowy adres</label></div>
										<div class="col-4"><input type="text" id="FullyEditable" name="FullyEditable" class="form-control"></div>										
										<div class="col-2"><label for="InputIconSelector" class=" form-control-label">Ikona</label></div>
										<div class="col-4 input-group">
											<img src="img/alert.png" id="icon-prev" class="mr-1">
											<select name="InputIconSelector" id="InputIconSelector" onchange="ChangeIcon()" class="form-control">
												{foreach $icons item=icon}
												<option class="imagebacked">{$icon}</option>
												{/foreach}
											</select>
										</div>	
									</div>
									<div class="row form-group">
										<div class="col-2"><label for="InputModeSelector" class=" form-control-label">Ustaw jako</label></div>
										<div class="col-3">
											<select name="InputModeSelector" id="InputModeSelector" onchange="ChangeInput()" class="form-control">
												<option value="1" id="IOIn">Wejście</option>
												<option value="2" id="IOOut">Wyjście binarne</option>
												<option value="3" id="IOOutPWM">Wyjście PWM</option>
											</select>
										</div>
										<div class="col-2"><label for="htmlcolor" class=" form-control-label">Kolor</label></div>
										<div class="col-2"><input type="color" id="htmlcolor" name="htmlcolor" class="form-control"></div>						
										<div class="col-2"><label for="InputConf" class=" form-control-label">Zaneguj wyjście</label></div>
										<div class="col-1">
											<label class="switch switch-3d switch-secondary mr-3"><input type="checkbox" class="switch-input" name="InputConf"> <span class="switch-label"></span> <span class="switch-handle"></span></label>
										</div>
									</div>									
								</div>
								<div class="card-footer">
									<button type="submit" class="btn btn-primary btn-sm">
										<i class="fa fa-save"></i> Zapisz
									</button>
								</div>								
							</section>
						</form>
                    </div>
				</div>
			</div>
		</div>
	


{include "footer.tpl"}
