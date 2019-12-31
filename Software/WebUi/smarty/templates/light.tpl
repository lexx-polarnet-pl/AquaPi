{include "header.tpl"}

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-6">
						<form action="light.php" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Ustawienia</strong>
                                </div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-6"><label for="PWM1" class=" form-control-label">PWM1</label></div>
										<div class="col-4"><input type="number" id="PWM1" name="PWM1" class="form-control" value="{$CONFIG.light_pwm1}" required min=0 max=100 step=1></div>
										<div class="col-2"><label for="PWM1" class=" form-control-label">%</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="PWM2" class=" form-control-label">PWM2</label></div>
										<div class="col-4"><input type="number" id="PWM2" name="PWM2" class="form-control" value="{$CONFIG.light_pwm2}" required min=0 max=100 step=1></div>
										<div class="col-2"><label for="PWM2" class=" form-control-label">%</label></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="T1" class=" form-control-label">T1</label></div>
										<div class="col-6"><input type="time" id="T1" name="T1" class="form-control" value="{$CONFIG.light_t1|utcdate_format:"%H:%M"}" required></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="T2" class=" form-control-label">T2</label></div>
										<div class="col-6"><input type="time" id="T2" name="T2" class="form-control" value="{$CONFIG.light_t2|utcdate_format:"%H:%M"}" required></div>
									</div>
									<div class="row form-group">
										<div class="col-6"><label for="TL" class=" form-control-label">TL</label></div>
										<div class="col-6"><input type="time" id="TL" name="TL" class="form-control" value="{$CONFIG.light_tl|utcdate_format:"%H:%M"}" required></div>
									</div>									
									<div class="row form-group">
										<div class="col-6"><label for="interface" class=" form-control-label">Wyjście</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.light_interface==$interface.interface_id}<img id="img-interface" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="interface" id="interface" class="form-control" required onchange="imgchange('img-interface','interface')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==3}
												<option value="{$interface.interface_id}" data-imagesrc="img/devices/{$interface.interface_icon}"{if $CONFIG.light_interface==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
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
                            <div class="card-body text-secondary"><img src="img/light_pwm.svg"></img></div>
                        </section>
                    </div>
				</div>
			</div>
		</div>
				
{include "footer.tpl"}