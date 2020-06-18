            <div id="main-menu" class="main-menu collapse navbar-collapse">
                <ul class="nav navbar-nav">
{foreach from=$my_menu item=pos}
{if $pos.submenu}
                    <li class="menu-item-has-children dropdown{if $pos.selected==true} show{/if}">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="menu-icon fa {$pos.icon}"></i>{$pos.name}</a>
                        <ul class="sub-menu children dropdown-menu{if $pos.selected==true} show{/if}">
{foreach from=$pos.submenu item=subpos}						
                            {if $subpos.selected==true}<li class="active">{else}<li class="">{/if}<i class="menu-icon fa {$subpos.icon}"></i><a href="{$subpos.url}">{$subpos.name}</a></li>
{/foreach}								
                        </ul>
                    </li>
{else}
{if $pos.selected==true}<li class="active">{else}<li class="">{/if}
<a href="{$pos.url}"> <i class="menu-icon fa {$pos.icon}"></i>{$pos.name}</a>
</li>
{/if}
{/foreach}				
                </ul>
            </div><!-- /.navbar-collapse -->



