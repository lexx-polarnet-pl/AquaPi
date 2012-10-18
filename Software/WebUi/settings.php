<?php

include("init.php");
if ($_POST['day_start'] > "") {
	$pieces = explode(":", $_POST['day_start']);
	$day_start = intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
	$query = 'update settings set value="' . $day_start . '" where `key`= "day_start";';
	$db->Execute($query);

	$pieces = explode(":", $_POST['day_stop']);
	$day_stop = intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
	$query = 'update settings set value="' . $day_stop . '" where `key`= "day_stop";';
	$db->Execute($query);
	
	$query = 'update settings set value="' . $_POST['temp_sensor'] . '" where `key`="temp_sensor";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_day'] . '" where `key`="temp_day";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_night'] . '" where `key`="temp_night";';
	$db->Execute($query);

}

$temp_day = $db->GetOne("select value from settings where `key`='temp_day';");
$temp_night = $db->GetOne("select value from settings where `key`='temp_night';");

$day_start = $db->GetOne("select value from settings where `key`='day_start';");
$day_stop = $db->GetOne("select value from settings where `key`='day_stop';");

$temp_sensor = $db->GetOne("select value from settings where `key`='temp_sensor';");


$smarty->assign('temp_day', $temp_day);
$smarty->assign('temp_night', $temp_night);
date_default_timezone_set('UTC');
$smarty->assign('day_start', date("H:i:s",$day_start));
$smarty->assign('day_stop', date("H:i:s",$day_stop));
date_default_timezone_set("Europe/Warsaw");
$smarty->assign('temp_sensor', $temp_sensor);

//$settings = $db->GetAll('select * from settings;');
//$smarty->assign('settings', $settings);
$smarty->display('settings.tpl');
?>
