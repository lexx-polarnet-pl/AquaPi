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
<!-- czy daemon działa -->
{if $daemon_data->daemon->pid == null}
            <div class="col-sm-12">
                <div class="alert  alert-danger alert-dismissible fade show" role="alert">
                    <span class="badge badge-pill badge-danger">Uwaga</span> Brak komunikacji z daemonem. Pobranie danych z czujników nie jest możliwe.
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
						<section class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Dane pomiarowe</strong>
							</div>
							<div class="card-body card-block">
{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}
								<div class="row form-group">
									<div class="col-9"><img src="img/devices/{$interface.interface_icon}"> {$interface.interface_name}</div>
									<div class="col-3 text-right">
										<a href="?action=edit&id={$interface.interface_id}" class="btn btn-success btn-sm">
											<i class="fa fa-pencil-square-o"></i>&nbsp;Kalibruj
										</a>																
									</div>
								</div>
								<div class="row form-group">									
									<div class="col-5"><input type="text" id="DATA_RAW_{$interface.interface_id}" name="DATA_RAW_{$interface.interface_id}" class="form-control" value="Brak danych" readonly></div>
									<div class="col-2 text-center">⇉</div>
									<div class="col-5"><input type="text" id="DATA_CAL_{$interface.interface_id}" name="DATA_CAL_{$interface.interface_id}" class="form-control" value="Brak danych" readonly></div>
								</div>
{/if}{/foreach}
							</div>								
						</section>
                    </div>
{if $edit}
                    <div class="col-lg-6">
						<form action="?action=update&id={$edit}" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Dane kalibracyjne</strong>
								</div>
									
								<div class="card-body card-block">
{foreach from=$interfaces item="interface"}{if $interface.interface_id==$edit}
									<div class="row form-group">
										<div class="col-12"><img src="img/devices/{$interface.interface_icon}"> {$interface.interface_name}</div>
									</div>
{/if}{/foreach}			
									<div class="row form-group">
										<div class="col-6"><label for="DATA_RAW" class=" form-control-label">Odczyt bezpośredni</label></div>
										<div class="col-6"><input type="text" id="DATA_RAW" name="DATA_RAW" class="form-control" value="Brak danych" readonly></div>
									</div>	
									<div class="row form-group">
										<div class="col-12">
											<canvas id="myCanvas" style="width:100%; height:100px;">
												Your browser does not support the canvas element.
											</canvas>
										</div>
									</div>	
									<div class="row form-group">
										<div class="col-6"><label for="DATA_CAL" class=" form-control-label">Odczyt przeliczony</label></div>
										<div class="col-6"><input type="text" id="DATA_CAL" name="DATA_CAL" class="form-control" value="Brak danych" readonly></div>
									</div>	
									<div class="row form-group">
										<div class="col-12"><label class=" form-control-label">Wyznaczenie punktów korekcji</label></div>
									</div>		
									<div class="row form-group">
										<div class="col-6 input-group">
											<input type="number" id="raw1" name="raw1" class="form-control" value="{$raw1}" step=0.0001 required>
											<div class="input-group-addon" onclick="javascript:copyval1()"><i class="fa fa-paste"></i></div>
										</div>
										<div class="col-6"><input type="number" id="cal1" name="cal1" class="form-control" value="{$cal1}" step=0.01 required></div>
									</div>	
									<div class="row form-group">
										<div class="col-6 input-group">
											<input type="number" id="raw2" name="raw2" class="form-control" value="{$raw2}" step=0.0001 required>
											<div class="input-group-addon" onclick="javascript:copyval2()"><i class="fa fa-paste"></i></div>
										</div>
										<div class="col-6"><input type="number" id="cal2" name="cal2" class="form-control" value="{$cal2}" step=0.01 required></div>
									</div>										
								</div>								
								<div class="card-footer">
									<button type="submit" class="btn btn-primary btn-sm">
										<i class="fa fa-save"></i> Zapisz
									</button>
									<button type="reset" class="btn btn-warning btn-sm">
										<i class="fa fa-ban"></i> Reset
									</button>		
{if $calibration_records==0}
									<button type="button" class="btn btn-danger btn-sm" DISABLED>
										<i class="fa fa-times"></i> Usuń dane kalibracyjne
									</button>
{else}
									<a href="?action=delete&id={$edit}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć dane kalibracyjne?');">
										<button type="button" class="btn btn-danger btn-sm"{if $calibration_records==0} DISABLED{/if}>
											<i class="fa fa-times"></i> Usuń dane kalibracyjne
										</button>
									</a>
{/if}
								</div>
							</section>
						</form>
                    </div>
{/if}
				</div>
			</div>
		</div>					


<!--Ajax - odświerzanie danych -->

<script type="text/javascript">

ValuesList = new Array(100);

function copyval1() {
	document.getElementById("raw1").value = document.getElementById("DATA_RAW").value;
}

function copyval2() {
	document.getElementById("raw2").value = document.getElementById("DATA_RAW").value;
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
  var i,j;
  var xmlDoc = xml.responseXML;
  var x = xmlDoc.getElementsByTagName("device");
  for (i = 0; i <x.length; i++) {
	dev_id = parseInt(x[i].getElementsByTagName("id")[0].childNodes[0].nodeValue);
	dev_measured_value = parseFloat(x[i].getElementsByTagName("measured_value")[0].childNodes[0].nodeValue);
	dev_raw_measured_value = parseFloat(x[i].getElementsByTagName("raw_measured_value")[0].childNodes[0].nodeValue);
	elem = document.getElementById("DATA_RAW_"+dev_id.toString())
	if (elem !== null) {
		elem.value = dev_raw_measured_value;
	}
	elem = document.getElementById("DATA_CAL_"+dev_id.toString())
	if (elem !== null) {
		elem.value = dev_measured_value;
	}	
{if $edit}
	if (dev_id == {$edit}) { 
		elem = document.getElementById("DATA_RAW")
		if (elem !== null) {
			elem.value = dev_raw_measured_value;
		}
		elem = document.getElementById("DATA_CAL")
		if (elem !== null) {
			var raw1 = parseFloat(document.getElementById("raw1").value);
			var cal1 = parseFloat(document.getElementById("cal1").value);
			var raw2 = parseFloat(document.getElementById("raw2").value);
			var cal2 = parseFloat(document.getElementById("cal2").value);
			// wylicz współczynniki równania liniowego zakładając że mierniki pH mają liniową charakterystykę
			var a = (cal2-cal1)/(raw2-raw1);
			var b = cal1-a*raw1;
			// podaj skonwertowane dane z pomocą funkcji liniowej
			elem.value = dev_raw_measured_value*a+b;
			// przesuń bufor danych i określ min/max
			min = dev_raw_measured_value;
			max = dev_raw_measured_value;
			for (j = 100; j > 0; j--) {
				ValuesList[j] = ValuesList[j-1];
				if (ValuesList[j]<min) {
					min = ValuesList[j];
				}
				if (ValuesList[j]>max) {
					max = ValuesList[j];
				}				
			}
			// dodaj nową liczbę do bufora
			ValuesList[0] = dev_raw_measured_value;		
			if (min == max) { max = min + 1}	
		}
		// narysuj wykres
		var canvas = document.getElementById("myCanvas");
		var ctx = canvas.getContext("2d");
		var bar_width = canvas.width/100;
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		//ctx.fillStyle = "#FF0000";
		ctx.beginPath();
		ctx.moveTo(canvas.width, canvas.height-(ValuesList[j]-min)*(canvas.height/(max-min))); 
		for (j = 1; j < 100; j++) {
			ctx.lineTo(canvas.width-j*bar_width, canvas.height-(ValuesList[j]-min)*(canvas.height/(max-min))); 
		}	
		ctx.stroke();
		ctx.fillText(max, 0, 20);
		ctx.fillText(min, 0, canvas.height-10);
	}
{/if}
  };
}

// odświerzaj dane na stronie co 1 sekune
window.onload = function() {            
    setInterval("AjaxRefresh()",1000)
}
</script>	

{include "footer.tpl"}