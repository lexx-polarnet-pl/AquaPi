{include "header.tpl"}

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-6">
						<form action="temp.php" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Ustawienia</strong>
                                </div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-6"><label for="TMAX" class=" form-control-label">Tmax</label></div>
										<div class="col-4"><input type="number" id="TMAX" name="TMAX" class="form-control" value="{$CONFIG.temp_tmax}" required min=15 max=30 step=0.5></div>
										<div class="col-2"><label for="TMAX" class=" form-control-label">&deg;C</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="HC" class=" form-control-label">Hc</label></div>
										<div class="col-4"><input type="number" id="HC" name="HC" class="form-control" value="{$CONFIG.temp_hc}" required min=0 max=5 step=0.1></div>
										<div class="col-2"><label for="HC" class=" form-control-label">&deg;C</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="TMIN" class=" form-control-label">Tmin</label></div>
										<div class="col-4"><input type="number" id="TMIN" name="TMIN" class="form-control" value="{$CONFIG.temp_tmin}" required min=15 max=30 step=0.5></div>
										<div class="col-2"><label for="TMIN" class=" form-control-label">&deg;C</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="HG" class=" form-control-label">Hg</label></div>
										<div class="col-4"><input type="number" id="HG" name="HG" class="form-control" value="{$CONFIG.temp_hg}" required min=0 max=5 step=0.1></div>
										<div class="col-2"><label for="HG" class=" form-control-label">&deg;C</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="NCOR" class=" form-control-label">Ncor</label></div>
										<div class="col-4"><input type="number" id="NCOR" name="NCOR" class="form-control" value="{$CONFIG.temp_ncor}" required min=-5 max=0 step=0.1></div>
										<div class="col-2"><label for="NCOR" class=" form-control-label">&deg;C</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="interface_heat" class=" form-control-label">Grzałka</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.temp_interface_heat==$interface.interface_id}<img id="img-interface_heat" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="interface_heat" id="interface_heat" class="form-control" required onchange="imgchange('img-interface_heat','interface_heat')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
												<option value="{$interface.interface_id}" {if $CONFIG.temp_interface_heat==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>	
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="interface_cool" class=" form-control-label">Chłodzenie</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.temp_interface_cool==$interface.interface_id}<img id="img-interface_cool" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="interface_cool" id="interface_cool" class="form-control" required onchange="imgchange('img-interface_cool','interface_cool')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==2}
												<option value="{$interface.interface_id}" {if $CONFIG.temp_interface_cool==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
										</div>	
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="interface_sensor" class=" form-control-label">Czujnik temperatury</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.temp_interface_sensor==$interface.interface_id}<img id="img-interface_sensor" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="interface_sensor" id="interface_sensor" class="form-control" required onchange="imgchange('img-interface_sensor','interface_sensor')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}
												<option value="{$interface.interface_id}" {if $CONFIG.temp_interface_sensor==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
												{/if}{/foreach}
											</select>
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
							</section>
						</form>
                    </div>
                    <div class="col-lg-6">
                        <section class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Objaśnienie działania</strong>
							</div>						
                            <div class="card-body text-secondary"><img src="img/temp.svg" align="right"></img></div>
                        </section>
                    </div>
				</div>

                <div class="row">
                    <div class="col-lg-12">
                        <section class="card">
							<div class="card-header">
								<strong class="card-title" v-if="headerText">Legenda</strong>
							</div>						
                            <div class="card-body text-secondary">
								<table>
								<tr><td>Tzad</td><td>-</td><td>Temperatura zadana. To jest wartość wirtualna, tylko żeby się orientować w działaniu sterownika. Nie występuje w ustawieniach.</td></tr>
								<tr><td>Tmax</td><td>-</td><td>Temperatura maksymalna. Przekroczenie tej temperatury powoduje załączenie chłodzenia.</td></tr>
								<tr><td>Hc</td><td>-</td><td>Histereza chłodzenia. Chłodzenie będzie tak długo aktywne, aż aktualna temperatura spadnie poniżej poziomu Tmax - Hc.</td></tr>
								<tr><td>Tmin</td><td>-</td><td>Temperatura minimalna. Zejście poniżej tej temperatury powoduje załączenie ogrzewania.</td></tr>
								<tr><td>Hg</td><td>-</td><td>Histereza grzania. Grzanie będzie tak długo aktywne, aż aktualna temperatura wzrośnie powyżej poziomu Tmin + Hg.</td></tr>
								<tr><td>Ncor</td><td>-</td><td>Korekta nocna. Ustawienie niezerowej wartości spowoduje że zostanie ona dodana do parametrów Tmax, Hc, Tmin, Hg. Przykładowo ustawienie -2&deg;C spowoduje że system będzie starał się utrzymywać temperaturę w nocy o 2&deg;C niższą niż w dzień.</td></tr>
								</table>
							</div>
                        </section>
                    </div>
                </div>
			</div>
		</div>
				
{include "footer.tpl"}