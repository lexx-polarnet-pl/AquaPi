{include "header.tpl"}

<!-- czy daemon działa -->
{if $daemon_data->daemon->pid == null}
            <div class="col-sm-12">
                <div class="alert  alert-danger alert-dismissible fade show" role="alert">
                    <span class="badge badge-pill badge-danger">Uwaga</span> Brak komunikacji z daemonem. Pobranie odczytu z sondy pH nie jest możliwe.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </div>
{/if}

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-6">
						<form action="co2.php?op=sets" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Ustawienia nawożenia CO<sub>2</sub></strong>
								</div>
									
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-6"><label for="PHPROBE" class="form-control-label">Wejście sondy</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.co2_probe==$interface.interface_id}<img id="IMG-PHPROBE" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="PHPROBE" id="PHPROBE" class="form-control" required onchange="imgchange('IMG-PHPROBE','PHPROBE')"> 
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}
												<option value="{$interface.interface_id}" title="img/devices/{$interface.interface_icon}"{if $CONFIG.co2_probe==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>	
									</div>	
									<div class="row form-group">
										<div class="col-6"><label for="CO2EN" class=" form-control-label">Elektrozawór butli</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.co2_co2valve==$interface.interface_id}<img id="IMG-CO2EN" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="CO2EN" id="CO2EN" class="form-control" required onchange="imgchange('IMG-CO2EN','CO2EN')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
												<option value="{$interface.interface_id}" data-imagesrc="img/devices/{$interface.interface_icon}"{if $CONFIG.co2_co2valve==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>	
									</div>	
									<div class="row form-group">
										<div class="col-6"><label for="CO2PH" class=" form-control-label">Otwórz zawór gdy pH przekroczy:</label></div>
										<div class="col-4"><input type="number" id="CO2PH" name="CO2PH" class="form-control" value="{$CONFIG.co2_co2limit}" step=0.1 required></div>
										<div class="col-2"><label for="CO2PH" class=" form-control-label">pH</label></div>
									</div>	
									
									<div class="row form-group">
										<div class="col-6"><label for="O2EN" class=" form-control-label">Napowietrzacz</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.co2_o2valve==$interface.interface_id}<img id="IMG-O2EN" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="O2EN" id="O2EN" class="form-control" required onchange="imgchange('IMG-O2EN','O2EN')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
												<option value="{$interface.interface_id}" data-imagesrc="img/devices/{$interface.interface_icon}"{if $CONFIG.co2_o2valve==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>	
									</div>	
									<div class="row form-group">
										<div class="col-6"><label for="O2PH" class=" form-control-label">Uruchom napowietrzacz gdy pH spadnie poniżej:</label></div>
										<div class="col-4"><input type="number" id="O2PH" name="O2PH" class="form-control" value="{$CONFIG.co2_o2limit}" step=0.1 required></div>
										<div class="col-2"><label for="O2PH" class=" form-control-label">pH</label></div>
									</div>	
									<div class="row form-group">
										<div class="col-6"><label for="hysteresis" class=" form-control-label">Histereza:</label></div>
										<div class="col-4"><input type="number" id="hysteresis" name="hysteresis" class="form-control" value="{$CONFIG.co2_hysteresis}" step=0.1 required></div>
										<div class="col-2"><label for="hysteresis" class=" form-control-label">pH</label></div>
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
							</section>
						</form>
                    </div>


				</div>
			</div>
		</div>					


<!--Ajax - odświerzanie danych -->

<script type="text/javascript">
function copyval1() {
	document.getElementById("MV1").value = document.getElementById("PRACT").value;
}

function copyval2() {
	document.getElementById("MV2").value = document.getElementById("PRACT").value;
}

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
  var sel_in = parseInt(document.getElementById("PHPROBE").value);
  var ph1 = parseFloat(document.getElementById("PH1").value);
  var ph2 = parseFloat(document.getElementById("PH2").value);
  var mv1 = parseFloat(document.getElementById("MV1").value);
  var mv2 = parseFloat(document.getElementById("MV2").value);
  // wylicz współczynniki równania liniowego zakładając że mierniki pH mają liniową charakterystykę
  var a = (ph2-ph1)/(mv2-mv1);
  var b = ph1-a*mv1;
  for (i = 0; i <x.length; i++) {
	dev_id = parseInt(x[i].getElementsByTagName("id")[0].childNodes[0].nodeValue);
	if (dev_id == sel_in) { 
		// pobierz surowe dane
		dev_measured_value = parseFloat(x[i].getElementsByTagName("raw_measured_value")[0].childNodes[0].nodeValue);
		// podaj surowe dane
		document.getElementById("PRACT").value = dev_measured_value.toFixed(4);
		// podaj skonwertowane dane z pomocą funkcji liniowej
		document.getElementById("PHACT").value = (dev_measured_value*a+b).toFixed(2);
	};
  };
}

// odświerzaj dane na stronie co 1 sekune
window.onload = function() {            
    setInterval("AjaxRefresh()",1000)
}
</script>	

{include "footer.tpl"}