{include "header.tpl"}

<!-- czy daemon działa -->
{if $daemon_data->daemon->pid == null}
            <div class="col-sm-12">
                <div class="alert  alert-danger alert-dismissible fade show" role="alert">
                    <span class="badge badge-pill badge-danger">Uwaga</span> Brak komunikacji z daemonem. Część informacji nie jest dostępna.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </div>
{/if}
			
<!-- sensory -->
	{foreach from=$status.aquapi.devices.device item="device"}
	    {if $device.type == 1}	
			<div class="col-lg-3 col-md-6">
				<div class="card">
					<div class="card-body">
						<div class="stat-widget-one">
							<div class="stat-icon dib">
							    <span class="stat-icon dib btn bg-transparent">
									<img src="img/devices/{$icons[{$device.id}]}">
								</span>
							</div>
							<div class="stat-content dib">
								<div class="stat-text">{$device.name}</div>
								<div class="stat-digit">{$device.measured_value|string_format:"%.1f"} {$interfaceunits[{$device.id}]}</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		{/if}
	{/foreach}
<!-- wyjścia -->
	{foreach from=$status.aquapi.devices.device item="device"}
	    {if $device.type == 2 || $device.type == 3}	
			<div class="col-lg-3 col-md-6">
				<div class="card">
					<div class="card-body">
						<div class="stat-widget-one">
							<div class="stat-icon dib">
							    <button class="stat-icon dib btn bg-transparent" type="button" id="dropdownMenuButton{$device.id}" data-toggle="dropdown">
									<img src="img/devices/{$icons[{$device.id}]}">
								</button>
								<div class="dropdown-menu" aria-labelledby="dropdownMenuButton{$device.id}">
									<div class="dropdown-menu-content">
										{if $device.type == 2}
										<a class="dropdown-item" href="interface_cmds.php?interface_id={$device.id}&action=on">Załącz</a>
										<a class="dropdown-item" href="interface_cmds.php?interface_id={$device.id}&action=off">Wyłącz</a>
										<a class="dropdown-item" href="interface_cmds.php?interface_id={$device.id}&action=auto">Przejdź w tryb automatyczny</a>
										{else}
										<a class="dropdown-item" href="#">Dla wyjść PWM na razie pusto...</a>
										{/if}
									</div>
								</div>
							</div>
							<div class="stat-content dib">
								<div class="stat-text">{$device.name}</div>
								{if $device.type == 2}
								<div class="stat-digit">{if $device.state == -1}<span class="badge badge-warning">Nieokreślony</span>{elseif $device.state == 1}<span class="badge badge-success">Włączony</span>{else}<span class="badge badge-danger">Wyłączony</span>{/if}</div>
								{else}
								<div class="stat-digit">{if $device.state == -1}<span class="badge badge-warning">Nieokreślony</span>{else}<span class="badge badge-info">PWM:{$device.state}%</span>{/if}</div>
								{/if}
								<div class="stat-text">{if $device.override_value == -1}<span class="badge badge-secondary">Tryb automatyczny</span>{else}<span class="badge badge-primary">Tryb ręczny</span>{/if}</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		{/if}
	{/foreach}

<!--Informacje o sterowniku-->
{include "index_aquainfo.tpl"}
		
{include "footer.tpl"}