{include "header.tpl"}

        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="service.php" method="post" class="form-horizontal">
							<section class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Ustawienia</strong>
                                </div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-6"><label for="service_mode_input" class=" form-control-label">Wejście trybu serwisowego</label></div>
										<div class="col-6 input-group">
											{foreach from=$interfaces item="interface"}{if $CONFIG.service_mode_input==$interface.interface_id}<img id="img-interface_sensor" class="mr-1" src="img/devices/{$interface.interface_icon}">{/if}{/foreach}
											<select name="service_mode_input" id="service_mode_input" class="form-control" required onchange="imgchange('img-interface_sensor','service_mode_input')">
												{foreach from=$interfaces item="interface"}{if $interface.interface_type==1}
												<option value="{$interface.interface_id}" {if $CONFIG.service_mode_input==$interface.interface_id} selected{/if}>{$interface.interface_name}</option>
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
				</div>


				
{include "footer.tpl"}