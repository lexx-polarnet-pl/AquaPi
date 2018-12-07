{include "header.tpl"}
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">

                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <strong class="card-title">Strona: {for $page=0 to $pages-1}<a href="logs.php?&offset={$page}">{$page+1}</a> {/for}</strong>
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
								<strong class="card-title">Strona: {for $page=0 to $pages-1}<a href="logs.php?&offset={$page}">{$page+1}</a> {/for}</strong>
							</div>							
                        </div>
                    </div>										
                </div>
            </div><!-- .animated -->
        </div><!-- .content -->

{include "footer.tpl"}