{include "header.tpl"}
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">

                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
								<div class="row">	
									<div class="col-md-6">
										<strong class="card-title">Strona {$curr_page} z {$pages} ({$count} wpisów na stronę).</strong>
									</div>
									<div class="col-md-6 text-right">
										<strong class="card-title">
											<button type="button" {if $curr_page==1} disabled="disabled" {/if}class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset=0'"><i class="fa fa-angle-double-left"></i></button>
											<button type="button" {if $curr_page==1} disabled="disabled" {/if}class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$curr_page-2}'"><i class="fa fa-angle-left"></i></button>
											{for $page=0 to $pages-1}
											{if $curr_page - $page < 5 && $curr_page - $page > -3}
											<button type="button" {if $page+1==$curr_page}class="btn btn-success btn-sm" disabled="disabled"{else}class="btn btn-secondary btn-sm" {/if}onclick="window.location.href='logs.php?&offset={$page}'">{$page+1}</button>
											{/if}
											{/for}
											<button type="button" {if $curr_page==$pages} disabled="disabled" {/if} class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$curr_page}'"><i class="fa fa-angle-right"></i></button>
											<button type="button" {if $curr_page==$pages} disabled="disabled" {/if} class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$pages-1}'"><i class="fa fa-angle-double-right"></i></button>											
										</strong>	
									</div> 
								</div>
								<div class="row">							
									<div class="col-md-12">								
										<button type="button" class="btn btn{if $log_filter=="all"}-outline{/if}-primary btn-sm" onclick="window.location.href='logs.php?filter=all'">Pokazuj wszystko</button>
										<button type="button" class="btn btn{if $log_filter=="warn"}-outline{/if}-warning btn-sm" onclick="window.location.href='logs.php?filter=warn'">Pokazuj ostrzeżenia i błędy krytyczne</button>
										<button type="button" class="btn btn{if $log_filter=="crit"}-outline{/if}-danger btn-sm" onclick="window.location.href='logs.php?filter=crit'">Pokazuj tylko błędy krytyczne</button>
									</div>
								</div>
                            </div>
                            <div class="card-body">
								{foreach from=$logs item="entry"}
								{if $entry.log_level == 0}<div class="alert alert-info" role="alert">
								{elseif $entry.log_level == 1}<div class="alert alert-warning" role="alert">
								{elseif $entry.log_level == 2}<div class="alert alert-danger" role="alert">
								{else}
								{/if}
									{$entry.log_date|date_format:"%e.%m.%Y&nbsp;%H:%M:%S"}
									{if $entry.log_level == 0}<span class="badge badge-pill badge-info">Informacja</span>
									{elseif $entry.log_level == 1}<span class="badge badge-pill badge-warning">Ostrzeżenie</span>
									{elseif $entry.log_level == 2}<span class="badge badge-pill badge-danger">Błąd krytyczny</span>
									{else}
									{/if}									
									{$entry.log_value}
								</div>
							{/foreach}			
							</div>
							<div class="card-footer">
								<div class="row">	
									<div class="col-md-6">
										<strong class="card-title">Strona {$curr_page} z {$pages} ({$count} wpisów na stronę).</strong>
									</div>
									<div class="col-md-6 text-right">
										<strong class="card-title">
											<button type="button" {if $curr_page==1} disabled="disabled" {/if}class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset=0'"><i class="fa fa-angle-double-left"></i></button>
											<button type="button" {if $curr_page==1} disabled="disabled" {/if}class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$curr_page-2}'"><i class="fa fa-angle-left"></i></button>
											{for $page=0 to $pages-1}
											{if $curr_page - $page < 5 && $curr_page - $page > -3}
											<button type="button" {if $page+1==$curr_page}class="btn btn-success btn-sm" disabled="disabled"{else}class="btn btn-secondary btn-sm" {/if}onclick="window.location.href='logs.php?&offset={$page}'">{$page+1}</button>
											{/if}
											{/for}
											<button type="button" {if $curr_page==$pages} disabled="disabled" {/if} class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$curr_page}'"><i class="fa fa-angle-right"></i></button>
											<button type="button" {if $curr_page==$pages} disabled="disabled" {/if} class="btn btn-secondary btn-sm" onclick="window.location.href='logs.php?&offset={$pages-1}'"><i class="fa fa-angle-double-right"></i></button>											
										</strong>	
									</div> 
								</div>
							</div>							
                        </div>
                    </div>										
                </div>
            </div><!-- .animated -->
        </div><!-- .content -->

{include "footer.tpl"}