<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js" lang="en">
<!--<![endif]-->

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>AquaPI</title>
    <meta name="description" content="AquaPI">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="apple-touch-icon" href="apple-icon.png">
    <link rel="shortcut icon" href="favicon.ico">

    <link rel="stylesheet" href="vendors/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="vendors/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="vendors/themify-icons/css/themify-icons.css">
    <link rel="stylesheet" href="vendors/flag-icon-css/css/flag-icon.min.css">
    <link rel="stylesheet" href="vendors/selectFX/css/cs-skin-elastic.css">
    <link rel="stylesheet" href="vendors/jqvmap/dist/jqvmap.min.css">


    <link rel="stylesheet" href="assets/css/style.css">

    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,600,700,800' rel='stylesheet' type='text/css'>

</head>

<body>


    <!-- Left Panel -->

    <aside id="left-panel" class="left-panel">
        <nav class="navbar navbar-expand-sm navbar-default">

            <div class="navbar-header">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#main-menu" aria-controls="main-menu" aria-expanded="false" aria-label="Toggle navigation">
                    <i class="fa fa-bars"></i>
                </button>
                <a class="navbar-brand" href="./"><img src="img/logo.svg" alt="AquaPI"></a>
                <a class="navbar-brand hidden" href="./"><img src="img/logo2.svg" alt="AP"></a>
            </div>
			{include "menu.tpl"}
        </nav>
    </aside><!-- /#left-panel -->

    <!-- Left Panel -->

    <!-- Right Panel -->

    <script src="vendors/jquery/dist/jquery.min.js"></script>
    <script src="vendors/popper.js/dist/umd/popper.min.js"></script>
    <script src="vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="assets/js/main.js"></script>


    <script src="vendors/chart.js/dist/Chart.bundle.min.js"></script>
    <script src="assets/js/dashboard.js"></script>
    <script src="assets/js/widgets.js"></script>
    <script src="vendors/jqvmap/dist/jquery.vmap.min.js"></script>
    <script src="vendors/jqvmap/examples/js/jquery.vmap.sampledata.js"></script>
    <script src="vendors/jqvmap/dist/maps/jquery.vmap.world.js"></script>
    <script>
        (function($) {
            "use strict";

            jQuery('#vmap').vectorMap({
                map: 'world_en',
                backgroundColor: null,
                color: '#ffffff',
                hoverOpacity: 0.7,
                selectedColor: '#1de9b6',
                enableZoom: true,
                showTooltip: true,
                values: sample_data,
                scaleColors: ['#1de9b6', '#03a9f5'],
                normalizeFunction: 'polynomial'
            });
        })(jQuery);

		function imgchange(imgid,selectid) { // zmiana ikony urządzenia w listach rozwijanych
			var imglist = new Array();
		{foreach from=$interfaces item="interface"}
			imglist[{$interface.interface_id}] = "img/devices/{$interface.interface_icon}"; 
		{/foreach}	
			document.getElementById(imgid).src=imglist[document.getElementById(selectid).value]
		}		
    </script>
	
    <!-- Right Panel -->

    <div id="right-panel" class="right-panel">

        <!-- Header-->
        <header id="header" class="header">

            <div class="header-menu">

                <div class="col-sm-4">
                    <a id="menuToggle" class="menutoggle pull-left"><i class="fa fa fa-tasks"></i></a>
                    <div class="header-left">

                        <div class="dropdown for-message">
                            <button class="btn btn-secondary dropdown-toggle" type="button"
                                id="message"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa fa-bell"></i>
                                {if $lastwarnlogs|@count > 0}<span class="count bg-danger">{$lastwarnlogs|@count}</span>{/if}
                            </button>
                            <div class="dropdown-menu" aria-labelledby="message">
                                <p class="red">{if $lastwarnlogs|@count > 0}Masz {$lastwarnlogs|@count} nowych komunikatów o błędach{else}Brak nowych komunikatów o błędach{/if}</p>
								{foreach from=$lastwarnlogs item="entry"}								
                                <a class="dropdown-item media {if $entry.log_level == 1}bg-flat-color-3{elseif $entry.log_level == 2}bg-flat-color-4{/if}" href="logs.php">
									<span class="message media-body">
										<span class="name float-left">{$entry.log_date|date_format:"%e.%m.%Y&nbsp;%H:%M:%S"}</span>
										<span class="time float-right">({$entry.log_date|timeAgo} temu)</span>
											<p>{$entry.log_value}</p>
									</span>
								</a>
								{/foreach}		
                            </div>
                        </div>
                    </div>
                </div>

				<div class="col-sm-8">
					<div class="float-right">
						<h2>{$CONFIG.webui.motd}</h2>
					</div>
				</div>				
				
            </div>

        </header><!-- /header -->
        <!-- Header-->

        <div class="breadcrumbs">
            <div class="col-sm-12">
                <div class="page-header float-left">
                    <div class="page-title">
                        <h1>{$title}</h1>
                    </div>
                </div>
            </div>
            <!-- okruszków na razie nie potrzeba
			<div class="col-sm-8">
                <div class="page-header float-right">
                    <div class="page-title">
                        <ol class="breadcrumb text-right">
                            <li class="active">Dashboard</li>
                        </ol>
                    </div>
                </div>
            </div> -->
        </div>			