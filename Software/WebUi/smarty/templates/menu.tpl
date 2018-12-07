            <div id="main-menu" class="main-menu collapse navbar-collapse">
                <ul class="nav navbar-nav">
{foreach from=$my_menu item=pos}
{if $pos.selected==true}<li class="active">{else}<li class="">{/if}
<a href="{$pos.url}"> <i class="menu-icon fa {$pos.icon}"></i>{$pos.name}</a>
</li>
{/foreach}				

                    <h3 class="menu-title">Zewnętrzne</h3><!-- /.menu-title -->
                    <li class="menu-item-has-children dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="menu-icon fa fa-globe"></i>Strony</a>
                        <ul class="sub-menu children dropdown-menu">
                            <li><i class="menu-icon fa fa-home"></i><a href="http://aquapi.polarnet.pl">Aquapi page</a></li>
							<li><i class="menu-icon fa fa-globe"></i><a href="https://colorlib.com/polygon/sufee/">Sufee Admin</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!-- /.navbar-collapse -->



