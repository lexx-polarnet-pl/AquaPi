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
<!--LISTA ALERTÓW-->

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<section class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Lista alertów</strong>
							</div>							
							<div>
								<table id="bootstrap-data-table-export" class="table">
									<thead>
										<tr>
											<th>Interfejs</th>
											<th>Wartość wyzwolenia</th>
											<th>Tekst alarmu</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody>
									{foreach from=$alarms item="entry"}
										<tr>
											<td><img src="img/devices/{$entry.alarm_interfacethenicon}"> {$entry.alarm_interfacethenname}</td>
											<td>{if $entry.alarm_direction eq 1}&lt;{else}&gt;{/if} {$entry.alarm_action_level}</td>
											<td>{if $entry.alarm_level == 1}<span class="badge badge-pill badge-warning">Ostrzeżenie</span>
												{elseif $entry.alarm_level == 2}<span class="badge badge-pill badge-danger">Błąd krytyczny</span>{/if}
												{$entry.alarm_text}</td>
											<td>
												<a href="?action=delete&alarmid={$entry.alarm_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć ten alarm?');" class="btn btn-danger btn-sm">
													<i class="fa fa-times"></i> Usuń
												</a>
											</td>
										</tr>
									{/foreach}
									</tbody>
								</table>
							</div>
						</section>
                    </div>
				</div>
			</div>
		</div>			

<!--DODAWANIE NOWEGO ALERTU-->

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="alerts.php?action=add" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Dodaj nowy alert</strong>
                                </div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-2"><label for="alarm_interface_id" class=" form-control-label">Kiedy wejście</label></div>
										<div class="col-5 input-group">
											<img id="img-alarm_interface_id" class="mr-1" src="img/devices/{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}{$interface.interface_icon}{break}{/if}{/foreach}">
											<select name="alarm_interface_id" id="alarm_interface_id" class="form-control" required onchange="imgchange('img-alarm_interface_id','alarm_interface_id')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}
												<option value="{$interface.interface_id}">{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>
										<div class="col-2">
											<select name="alarm_direction" id="alarm_direction" class="form-control">
												<option value="1">&lt;</option>
												<option value="0">&gt;</option>
											</select>											
										</div>
										<div class="col=3">
											<input type="number" id="alarm_action_level" name="alarm_action_level" class="form-control" step=0.1 required>
										</div>
									</div>
									<div class="row form-group">
										<div class="col-2">Zgłoś alert</div>
										<div class="col-2">											
											<select name="alarm_level" id="alarm_level" class="form-control">
												<option value="1">Ostrzeżenie</option>
												<option value="2">Błąd krytyczny</option>
											</select>	
										</div>
										<div class="col-8"><input type="text" id="alarm_text" name="alarm_text" class="form-control" required></div>
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