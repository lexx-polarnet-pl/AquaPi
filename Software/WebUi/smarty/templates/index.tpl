{include "header.tpl"}

<!-- czy daemon działa -->
{if $status.aquapi.daemon.pid == null}
            <div class="col-sm-12">
                <div class="alert  alert-danger alert-dismissible fade show" role="alert">
                    <span class="badge badge-pill badge-danger">Uwaga</span> Brak komunikacji z daemonem. Część informacji nie jest dostępna.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </div>
{/if}
			<div class="card-columns px-md-3">			
<!-- sensory -->
{foreach from=$status.aquapi.devices.device item="device"}
{if $device.type == 1 && $device.dashboard == 1}	
				<div class="card">
					<div class="card-body">
						<div class="stat-widget-one">
							<div class="stat-icon dib">
							    <span class="stat-icon dib btn bg-transparent">
									<img src="img/devices/{$icons[{$device.id}]}">
								</span>
							</div>
							<div class="stat-content dib">
								<div class="stat-text">{$device.name}</div>
								<div class="stat-digit"><span id="{$device.id}">{$device.measured_value|string_format:"%.1f"}</span> {$interfaceunits[{$device.id}]}</div>
							</div>
						</div>
					</div>
				</div>
{/if}
{/foreach}
<!-- wyjścia -->
{foreach from=$status.aquapi.devices.device item="device"}
{if ( $device.type == 2 || $device.type == 3 ) && $device.dashboard == 1}	
				<div class="card">
					<div class="card-body">
						<div class="stat-widget-one">
							<div class="stat-icon dib">
							    <button class="stat-icon dib btn bg-transparent" type="button" id="dropdownMenuButton{$device.id}" data-toggle="dropdown">
									<img src="img/devices/{$icons[{$device.id}]}">
								</button>
								<div class="dropdown-menu" aria-labelledby="dropdownMenuButton{$device.id}">
									<div class="dropdown-menu-content">
										{if $device.type == 2}
										<a class="dropdown-item" href="#" onclick="AjaxCommand('interface_cmds.php?interface_id={$device.id}&action=on');">Załącz</a>
										<a class="dropdown-item" href="#" onclick="AjaxCommand('interface_cmds.php?interface_id={$device.id}&action=off');">Wyłącz</a>
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="#" onclick="AjaxCommand('interface_cmds.php?interface_id={$device.id}&action=auto');">Przejdź w tryb automatyczny</a>
										{else}
										<input class="dropdown-item" type="range" min="0" max="100" value="{$device.state}" onchange="AjaxCommand('interface_cmds.php?interface_id={$device.id}&action=pwm-' + this.value);">
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="#" onclick="AjaxCommand('interface_cmds.php?interface_id={$device.id}&action=auto');">Przejdź w tryb automatyczny</a>
										{/if}
									</div>
								</div>
							</div>
							<div class="stat-content dib">
								<div class="stat-text">{$device.name}</div>
								{if $device.type == 2}
								<div class="stat-digit"><span id="{$device.id}">{if $device.state == -1}<span class="badge badge-warning">Nieokreślony</span>{elseif $device.state == 1}<span class="badge badge-success">Włączony</span>{else}<span class="badge badge-danger">Wyłączony</span>{/if}</span></div>
								{else}
								<div class="stat-digit"><span id="{$device.id}">{if $device.state == -1}<span class="badge badge-warning">Nieokreślony</span>{else}<span class="badge badge-info">PWM:{$device.state}%</span>{/if}</span></div>
								{/if}
								<div class="stat-text"><span id="mode_{$device.id}">{if $device.override_value == -1}<span class="badge badge-secondary">Tryb automatyczny</span>{else}<span class="badge badge-primary">Tryb ręczny</span>{/if}</span></div>
							</div>
						</div>
					</div>
				</div>
{/if}
{/foreach}

<!--Informacje o sterowniku-->
{include "index_aquainfo.tpl"}
</div>	

<!--Ajax - odświerzanie danych -->
<script type="text/javascript">
function AjaxRefresh() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
	 AjaxProcess(this);
    }
  };
  xhttp.open("GET", "ajax_status.php", true);
  xhttp.send();
}

function AjaxProcess(xml) {
  var i;
  var xmlDoc = xml.responseXML;
  var x = xmlDoc.getElementsByTagName("device");
  for (i = 0; i <x.length; i++) {
	dev_id = x[i].getElementsByTagName("id")[0].childNodes[0].nodeValue;
	dev_type = parseInt(x[i].getElementsByTagName("type")[0].childNodes[0].nodeValue);
	dev_measured_value = parseFloat(x[i].getElementsByTagName("measured_value")[0].childNodes[0].nodeValue);
	dev_state = x[i].getElementsByTagName("state")[0].childNodes[0].nodeValue;
	dev_override_value = parseInt(x[i].getElementsByTagName("override_value")[0].childNodes[0].nodeValue);
	if (dev_type == 1) { // sensory
		if (dev_measured_value <= -100) {
			document.getElementById(dev_id).innerHTML = "Błąd odczytu";
		} else {
			document.getElementById(dev_id).innerHTML = dev_measured_value.toFixed(1);
		}
	};
	if (dev_type == 2) { // wejścia
		if (dev_state == -1) { 
			document.getElementById(dev_id).innerHTML = "<span class='badge badge-warning'>Nieokreślony</span>";
		} else if (dev_state == 1) {
			document.getElementById(dev_id).innerHTML = "<span class='badge badge-success'>Włączony</span>";
		} else {
			document.getElementById(dev_id).innerHTML = "<span class='badge badge-danger'>Wyłączony</span>";
		}
	};
	if (dev_type == 3) { // pwm
		if (dev_state == -1) { // stan nieokreślony
			document.getElementById(dev_id).innerHTML = "<span class='badge badge-warning'>Nieokreślony</span>";
		} else {
			document.getElementById(dev_id).innerHTML = "<span class='badge badge-info'>PWM:" + dev_state +"%</span>";
		}
	};
	if (dev_type == 2 || dev_type == 3 ) { // tryb działania dla wyjść
		if (dev_override_value == -1) {
			document.getElementById("mode_" + dev_id).innerHTML = "<span class='badge badge-secondary'>Tryb automatyczny</span>";
		} else {
			document.getElementById("mode_" + dev_id).innerHTML = "<span class='badge badge-primary'>Tryb ręczny</span>";
		}
	};
  };
}

function AjaxCommand(Command) {
  var xhttp = new XMLHttpRequest();
  xhttp.open("GET", Command, true);
  xhttp.send();
}

var count = 0;
	
function refreshers() {
	count++;
	AjaxRefresh();
	if (count >=10) {
		InfoAjaxRefresh();
		count = 0;
	}
}

window.onload = function() {            
    setInterval("refreshers()",1000)
}
</script>	

{include "footer.tpl"}