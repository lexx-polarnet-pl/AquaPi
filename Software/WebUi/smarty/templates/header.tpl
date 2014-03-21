<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Capriola&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
<title>AquaPi - {$cur_name}</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
{$reloadtime}
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
<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.6&libraries=places&sensor=false"></script>
</head>
<body>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<script type="text/javascript" language="JavaScript" src="js/overlib.js"></script>
{if !$ismobile}{include "menu.tpl"}{/if}
<h1>{$cur_name}</h1>