
						<div class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Informacje o sterowniku</strong>
							</div>							
							<div class="card-body card-block">

    <table>
	<tr>
	    <td>Czas</td><td><span id="server_time">{$time}</span></td>
	</tr>
	<tr>
	    <td>Uruchomiony:</td><td>{$enabled}</td>
	</tr>
	<tr>
	    <td>Wersja jądra:</td><td>{$sysinfo.aquapi.uname.version}</td>
	</tr>
	<tr>
	    <td>Kompilacja:</td><td>{$sysinfo.aquapi.uname.release}</td>
	</tr>
	<tr>
	    <td>Obciążenie:</td><td><span id="server_av1m">{$sysinfo.aquapi.sysinfo.load.av1m|number_format:2}</span>, 
								<span id="server_av5m">{$sysinfo.aquapi.sysinfo.load.av5m|number_format:2}</span>,
								<span id="server_av15m">{$sysinfo.aquapi.sysinfo.load.av15m|number_format:2}</span></td>
	</tr>
	<tr>
	    <td>Temperatura CPU:</td><td><span id="server_cputemp">{$sysinfo.aquapi.system.cputemp|string_format:"%.2f"}</span>&deg;C</td>
	</tr>
	<tr>
	    <td>Wersja AquaPi/DB:</td><td>{$aquapi_ver}/{$CONFIG.db_version}</td>
	</tr>
	<tr>
	    <td>PID demona:</td><td>{if $status.aquapi.daemon.pid == null}Nie uruchomiony{else}{$status.aquapi.daemon.pid}{/if}</td>
	</tr>
	<tr>
	    <td>Kompilacja demona:</td><td>{if  $status.aquapi.daemon.pid == null}Nie uruchomiony{else}{$status.aquapi.daemon.compilation_date|date_format:"%Y/%m/%d&nbsp;%H:%M"}{/if}</td>
	</tr>
    </table>


							</div>
						</div>
					
<!--Ajax - odświerzanie danych -->
<script type="text/javascript">
function InfoAjaxRefresh() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
	 InfoAjaxProcess(this);
    }
  };
  xhttp.open("GET", "ajax_sysinfo.php", true);
  xhttp.send();
}

function checkTime(i) {
  if (parseInt(i) < 10) {
	i = "0" + i
  };  // add zero in front of numbers < 10
  return i;
}

function InfoAjaxProcess(xml) {
  var xmlDoc = xml.responseXML;
  var server_system = xmlDoc.getElementsByTagName("system")[0];
  var server_sysinfo = xmlDoc.getElementsByTagName("sysinfo")[0];
  var server_load = server_sysinfo.getElementsByTagName("load")[0];

  ServerDateObj = new Date(server_system.getElementsByTagName("rawtime")[0].childNodes[0].nodeValue * 1000); 
  
  document.getElementById("server_time").innerHTML =checkTime(ServerDateObj.getHours()) + ":" + checkTime(ServerDateObj.getMinutes());
  document.getElementById("server_cputemp").innerHTML = parseFloat(server_system.getElementsByTagName("cputemp")[0].childNodes[0].nodeValue).toFixed(2);
  document.getElementById("server_av1m").innerHTML = parseFloat(server_load.getElementsByTagName("av1m")[0].childNodes[0].nodeValue).toFixed(2);
  document.getElementById("server_av5m").innerHTML = parseFloat(server_load.getElementsByTagName("av5m")[0].childNodes[0].nodeValue).toFixed(2);
  document.getElementById("server_av15m").innerHTML = parseFloat(server_load.getElementsByTagName("av15m")[0].childNodes[0].nodeValue).toFixed(2);
}

</script>	