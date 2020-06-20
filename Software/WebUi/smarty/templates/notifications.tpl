{include "header.tpl"}

<!-- czy daemon działa -->
{if $daemon_data->daemon->pid == null}
            <div class="col-sm-12">
                <div class="alert  alert-danger alert-dismissible fade show" role="alert">
                    <span class="badge badge-pill badge-danger">Uwaga</span> Brak komunikacji z daemonem. Wysłanie testowego emaila nie będzie możliwe.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </div>
{/if}

<!-- czy była próba wysłania maila -->
{if $email_test}
            <div class="col-sm-12">
                <div class="alert  alert-info alert-dismissible fade show" role="alert">
                    Nastąpiła próba wysyłki maila testowego na adres {$CONFIG.email_address}. 
					Wysyłka następuje przy użyciu komendy sytemowej "mail". Jeśli nie otrzymasz maila, sprawdź czy adres jest poprawny, i czy funkcja mail działa poprawnie.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </div>
{/if}

        <div class="content mt-12">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="notifications.php?op=update" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Powiadomienia email</strong>
								</div>
									
								<div class="card-body card-block">

									<div class="row form-group">
										<div class="col-4">Adres do wysyłki powiadomień</div>
										<div class="col-8"><input type="email" id="email" name="email" class="form-control" value="{$CONFIG.email_address}">
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
									<button type="button" class="btn btn-warning btn-sm" onclick="window.location.href='notifications.php?op=test'"{if $daemon_data->daemon->pid == null} disabled{/if}>
										<i class="fa fa-envelope-o"></i> Wyślij testowy email
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