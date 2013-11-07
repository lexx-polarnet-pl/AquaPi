<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
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
 * $Id:$
 */
 
include("init.php");

$smarty->assign('title', 'Ustawienia');

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

	$query = 'update settings set value="' . $_POST['temp_sensor2'] . '" where `key`="temp_sensor2";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_sensor3'] . '" where `key`="temp_sensor3";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_sensor4'] . '" where `key`="temp_sensor4";';
	$db->Execute($query);

        $query = 'update settings set value="' . $_POST['temp_sensor_corr'] . '" where `key`="temp_sensor_corr";';
        $db->Execute($query);
 
        $query = 'update settings set value="' . $_POST['temp_sensor2_corr'] . '" where `key`="temp_sensor2_corr";';
        $db->Execute($query);
 
        $query = 'update settings set value="' . $_POST['temp_sensor3_corr'] . '" where `key`="temp_sensor3_corr";';
        $db->Execute($query);
 
        $query = 'update settings set value="' . $_POST['temp_sensor4_corr'] . '" where `key`="temp_sensor4_corr";';
        $db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_day'] . '" where `key`="temp_day";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_night'] . '" where `key`="temp_night";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['temp_cool'] . '" where `key`="temp_cool";';
	$db->Execute($query);

	$query = 'update settings set value="' . $_POST['hysteresis'] . '" where `key`="hysteresis";';
	$db->Execute($query);

	foreach ($_POST as $key => $value) {
		$act_key = explode("_",$key);
		//var_dump($act_key);
		if ($act_key[0] == 'device') {
			$query = 'update devices set fname="' . $value . '" where `device`="' . $act_key[1] . '";';
			$db->Execute($query);
		}
	}
	//$query = 'update settings set value="' . $_POST['line_5'] . '" where `key`="gpio5_name";';
	//$db->Execute($query);

	//$query = 'update settings set value="' . $_POST['line_6'] . '" where `key`="gpio6_name";';
	//$db->Execute($query);
}

$temp_day = $db->GetOne("select value from settings where `key`='temp_day';");
$temp_night = $db->GetOne("select value from settings where `key`='temp_night';");
$temp_cool = $db->GetOne("select value from settings where `key`='temp_cool';");
$hysteresis = $db->GetOne("select value from settings where `key`='hysteresis';");
$day_start = $db->GetOne("select value from settings where `key`='day_start';");
$day_stop = $db->GetOne("select value from settings where `key`='day_stop';");

$temp_sensor = $db->GetOne("select value from settings where `key`='temp_sensor';");
$temp_sensor2 = $db->GetOne("select value from settings where `key`='temp_sensor2';");
$temp_sensor3 = $db->GetOne("select value from settings where `key`='temp_sensor3';");
$temp_sensor4 = $db->GetOne("select value from settings where `key`='temp_sensor4';");

$temp_sensor_corr = $db->GetOne("select value from settings where `key`='temp_sensor_corr';");
$temp_sensor2_corr = $db->GetOne("select value from settings where `key`='temp_sensor2_corr';");
$temp_sensor3_corr = $db->GetOne("select value from settings where `key`='temp_sensor3_corr';");
$temp_sensor4_corr = $db->GetOne("select value from settings where `key`='temp_sensor4_corr';");

$friendly_names = $db->GetAll('select device,fname,output from devices where output <> "disabled";');

$temp_sensors = NULL;

if(is_dir(ONEWIRE_DIR))
{
    $folder = dir(ONEWIRE_DIR);
    while($plik = $folder->read()) if (substr($plik,0,3) == '28-') $temp_sensors[] = $plik;
    $folder->close();
}

$smarty->assign('temp_day', $temp_day);
$smarty->assign('temp_cool', $temp_cool);
$smarty->assign('temp_night', $temp_night);
$smarty->assign('hysteresis', $hysteresis);
date_default_timezone_set('UTC');
$smarty->assign('day_start', date("H:i:s",$day_start));
$smarty->assign('day_stop', date("H:i:s",$day_stop));
date_default_timezone_set("Europe/Warsaw");
$smarty->assign('temp_sensor', $temp_sensor);
$smarty->assign('temp_sensor2', $temp_sensor2);
$smarty->assign('temp_sensor3', $temp_sensor3);
$smarty->assign('temp_sensor4', $temp_sensor4);
$smarty->assign('temp_sensors', $temp_sensors);
$smarty->assign('temp_sensor_corr', $temp_sensor_corr);
$smarty->assign('temp_sensor2_corr', $temp_sensor2_corr);
$smarty->assign('temp_sensor3_corr', $temp_sensor3_corr);
$smarty->assign('temp_sensor4_corr', $temp_sensor4_corr);

$smarty->assign('friendly_names', $friendly_names);

$settings = $db->GetAll('select * from settings;');
$smarty->assign('settings', $settings);


$smarty->display('settings.tpl');
?>
