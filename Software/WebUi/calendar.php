<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
 * USA.
 *
 */

include("init.php");
$smarty->assign('title', 'Kalendarz');

//MEGA brzydki hack - do poprawienia.

echo '<html>
<head>
<link href="http://fonts.googleapis.com/css?family=Capriola&subset=latin,latin-ext" rel="stylesheet" type="text/css">
<title>AquaPi - Kalendarz</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<meta name="viewport" content="width=device-width">
<link rel="stylesheet" type="text/css" href="css/aquapi.css" />
<link rel="stylesheet" type="text/css" href="css/timepicker.css" />
<link rel="stylesheet" type="text/css" href="css/popup.css" />
<link rel="shortcut icon" type="image/x-icon" href="img/favicon.png" />
<link href="css/smoothness/jquery-ui-1.9.0.custom.css" rel="stylesheet">
<script type="text/javascript" src="js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.9.0.custom.js"></script>
<script type="text/javascript" src="js/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="js/popup.js"></script>
<script type="text/javascript" src="js/aquapi.js"></script>
<script type="text/javascript" src="js/jxs_compressed.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.6&libraries=places&sensor=false"></script>
<link  href="http://fonts.googleapis.com/css?family=Reenie+Beanie:regular" rel="stylesheet" type="text/css"> 
</head>
<body>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<script type="text/javascript" language="JavaScript" src="js/overlib.js"></script>
<div id="menu">
<div id="icon">
<a href="index.php">
<img src="img/home.png" title="Dashboard">
</a>
</div>
<div id="icon">
<a href="timers.php">
<img src="img/timers.png" title="Timery">
</a>
</div>
<div id="icon">
<a href="settings.php">
<img src="img/settings.png" title="Ustawienia">
</a>
</div>
<div id="icon">
<a href="logs.php">
<img src="img/logs2.png" title="Zdarzenia">
</a>
</div>
<div id="icon">
<a href="stat.php">
<img src="img/graph.png" title="Statystyka">
</a>
</div>
<div id="icon">
<a href="notes.php">
<img src="img/notes.png" title="Notatki">
</a>
</div>
<div id="icon_select">
<a href="calendar.php">
<img src="img/calendar.png" title="Kalendarz">
</a>
</div>
<div id="icon">
<a href="about.php">
<img src="img/about.png" title="O sterowniku">
</a>
</div>
</div><h1>Kalendarz</h1>

<center>';

include 'plugins/calendar/includes/embed.php';

echo '</center>

</body>
</html>';


?>
