                    <div class="col-lg-6">
						<section class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Informacje o sterowniku</strong>
							</div>							
							<div class="card-body card-block">

    <table>
	<tr>
	    <td>Czas</td><td>{$time}</td>
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
	    <td>Obciążenie:</td><td>{$sysinfo.aquapi.sysinfo.load.av1m|number_format:2}, {$sysinfo.aquapi.sysinfo.load.av5m|number_format:2}, {$sysinfo.aquapi.sysinfo.load.av15m|number_format:2}</td>
	</tr>
	<tr>
	    <td>Temperatura CPU:</td><td>{$sysinfo.aquapi.system.cputemp|string_format:"%.2f"}&deg;C</td>
	</tr>
	<tr>
	    <td>Wersja AquaPi/DB:</td><td>{$aquapi_ver}/{$CONFIG.db_version}</td>
	</tr>
	<tr>
	    <td>PID demona:</td><td>{if $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->pid}{/if}</td>
	</tr>
	<tr>
	    <td>Kompilacja demona:</td><td>{if  $daemon_data->daemon->pid == null}Nie uruchomiony{else}{$daemon_data->daemon->compilation_date|date_format:"%Y/%m/%d&nbsp;%H:%M"}{/if}</td>
	</tr>
    </table>


							</div>
						</section>
					</div>							
