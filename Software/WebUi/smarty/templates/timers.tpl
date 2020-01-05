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

<!--LISTA TIMERÓW-->

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="timers.php?action=update" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Lista zdarzeń czasowych</strong>
                                </div>							
								<div>
									<table id="bootstrap-data-table-export" class="table">
										<thead>
											<tr>
												<th>Godzina</th>
												<th>Akcja</th>
												<th>Wyjście</th>
												<th>Pn</th>
												<th>Wt</th>
												<th>Śr</th>
												<th>Cz</th>
												<th>Pt</th>
												<th>So</th>
												<th>Nd</th>
												<th>&nbsp;</th>
											</tr>
										</thead>
										<tbody>
										{foreach from=$timers item="entry"}
											<tr>
												<td><input class="form-control" step="1" type="time" name="timers[{$entry.timer_id}][timeif]" id="timers[{$entry.timer_id}][timeif]" value="{if $entry.timer_timeif eq 0}00:00:00{else}{$entry.timer_timeif|utcdate_format:"%H:%M:%S"}{/if}"/></td>
												<td>
													<select name="timers[{$entry.timer_id}][action]" id="timers[{$entry.timer_id}][action]" class="form-control" onchange="document.getElementById('icon-prev-{$device.interface_id}').setAttribute('src','img/devices/' + document.getElementById('IconSelectorId{$device.interface_id}').value);">
														<option value="1" {if $entry.timer_action eq 1}selected{/if}>Załącz</option>
														<option value="0" {if $entry.timer_action eq 0}selected{/if}>Wyłącz</option>
													</select>	
												</td>
												<td><img src="img/devices/{$entry.timer_interfacethenicon}"> {$entry.timer_interfacethenname}</td>
												<td><input id="timers[{$entry.timer_id}][d2]" name="timers[{$entry.timer_id}][d2]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.1 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d3]" name="timers[{$entry.timer_id}][d3]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.2 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d4]" name="timers[{$entry.timer_id}][d4]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.3 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d5]" name="timers[{$entry.timer_id}][d5]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.4 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d6]" name="timers[{$entry.timer_id}][d6]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.5 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d7]" name="timers[{$entry.timer_id}][d7]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.6 eq 1} checked{/if}></td>
												<td><input id="timers[{$entry.timer_id}][d1]" name="timers[{$entry.timer_id}][d1]" value="1" class="form-check-input" type="checkbox"{if $entry.timer_days.0 eq 1} checked{/if}></td>												
												<td>
													<a href="?action=delete&timerid={$entry.timer_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz usunąć to zdarzenie?');" class="btn btn-danger btn-sm">
														<i class="fa fa-times"></i> Usuń
													</a>
												</td>
											</tr>
										{/foreach}
										</tbody>
									</table>
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
	

<!--ZDARZENIA CZASOWE-->

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="timers.php?action=add" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Dodaj nowe zdarzenie</strong>
                                </div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-3">W dni tygodnia:</div>
										<div class="col-1"><input type="checkbox" name="d2" value="1" checked="checked"/>Pn</div>
										<div class="col-1"><input type="checkbox" name="d3" value="1" checked="checked"/>Wt</div>
										<div class="col-1"><input type="checkbox" name="d4" value="1" checked="checked"/>Śr</div>
										<div class="col-1"><input type="checkbox" name="d5" value="1" checked="checked"/>Cz</div>
										<div class="col-1"><input type="checkbox" name="d6" value="1" checked="checked"/>Pt</div>
										<div class="col-1"><input type="checkbox" name="d7" value="1" checked="checked"/>So</div>
										<div class="col-1"><input type="checkbox" name="d1" value="1" checked="checked"/>Nd</div>
									</div>
									<div class="row form-group">
										<div class="col-2">O godzinie</div>
										<div class="col-2"><input class="form-control" step="1" type="time" name="timeif" id="timeif" required></div>
										<div class="col-2">
											<select name="action" id="action" class="form-control">
												<option value="1" selected>Załącz</option>
												<option value="0">Wyłącz</option>
											</select>	
										</div>
										<div class="col-2">wyjście</div>
										<div class="col-2">
											<select id="interfaceidthen" name="interfaceidthen" class="form-control">
											{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
												<option value="{$interface.interface_id}">{$interface.interface_name}</option>
											{/if}{/foreach}
											</select>										
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
