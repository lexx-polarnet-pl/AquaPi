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

if($CONFIG['plugins']['relayboard']==1)
{
	include(MODULES_DIR . "relayboard.php");
	$smarty->assign('relayboard_enable', 1);
}

$smarty->assign('title', 'Ustawienia');

//kasowanie czujnika przez $_GET
if(array_key_exists('action', $_GET))
	if ($_GET['action'] == "delete" and $_GET['id']>0)
	{
		$db->Execute('UPDATE sensors SET sensor_deleted=1 WHERE sensor_id=?', array($_GET['id']));
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}

if(array_key_exists('day_start', $_POST)) if ($_POST['day_start'] > "")
{
	$sensors	= $_POST['sensors'];
	
	$pieces 	= explode(":", $_POST['day_start']);
	$day_start 	= intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
	$db->Execute('UPDATE settings SET value=? where `key`= ?', array($day_start, 'day_start'));

	$pieces 	= explode(":", $_POST['day_stop']);
	$day_stop 	= intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
	$db->Execute('UPDATE settings SET value=? where `key`= ?', array($day_stop, 'day_stop'));

	foreach($sensors as $index => $sensor)
	{
		if(strlen($sensor['sensor_name'])>1 and $db->GetOne('SELECT 1 FROM sensors WHERE sensor_id=?', array($index))=="1") //jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		$db->Execute('UPDATE sensors SET sensor_name=?, sensor_address=?, sensor_corr=?, sensor_draw=? WHERE sensor_id=?', 
			array($sensor['sensor_name'], $sensor['sensor_address'], $sensor['sensor_corr'], $sensor['sensor_draw'], $index ));
		elseif(strlen($sensor['sensor_name'])>1) //jesli nie istnieje i jest podana nazwa dodaj czujnik
		{
			$db->Execute('INSERT INTO sensors(sensor_id, sensor_address, sensor_name, sensor_corr, sensor_draw)
				     VALUES (?, ?, ?, ?, ?)', array($index, $sensor['sensor_address'], $sensor['sensor_name'], $sensor['sensor_corr']));
		}
		
	}
	
	$db->Execute('update settings set value= ? where `key`= ?', array($_POST['temp_day'], "temp_day"));
	$db->Execute('update settings set value= ? where `key`= ?', array($_POST['temp_night'], "temp_night"));
	$db->Execute('update settings set value= ? where `key`= ?', array($_POST['temp_cool'], "temp_cool"));
	$db->Execute('update settings set value= ? where `key`= ?', array($_POST['hysteresis'], "hysteresis"));

	foreach ($_POST as $key => $value)
	{
		$act_key = explode("_",$key);
		if ($act_key[0] == 'device')
		{
			$db->Execute('update devices set fname= ? where device= ?', array($value, $act_key[1]));
		}
	}
	ReloadDaemonConfig();
}

$temp_day	= $db->GetOne("select value from settings where `key`='temp_day';");
$temp_night	= $db->GetOne("select value from settings where `key`='temp_night';");
$temp_cool	= $db->GetOne("select value from settings where `key`='temp_cool';");
$hysteresis	= $db->GetOne("select value from settings where `key`='hysteresis';");
$day_start	= $db->GetOne("select value from settings where `key`='day_start';");
$day_stop	= $db->GetOne("select value from settings where `key`='day_stop';");

$friendly_names = $db->GetAll('select device,fname,output from devices where output <> "disabled";');
$sensors	= $db->GetAll('SELECT * FROM sensors WHERE sensor_id>0 AND sensor_deleted=0');
$temp_sensors 	= NULL;

if(is_dir(ONEWIRE_DIR))
{
    $folder = dir(ONEWIRE_DIR);
    while($plik = $folder->read())
	if (substr($plik,0,3) == '28-')
		$temp_sensors[] = $plik;
    $folder->close();
}

$smarty->assign('temp_day', $temp_day);
$smarty->assign('temp_cool', $temp_cool);
$smarty->assign('temp_night', $temp_night);
$smarty->assign('hysteresis', $hysteresis);

$smarty->assign('day_start', date("H:i:s",$day_start));
$smarty->assign('day_stop', date("H:i:s",$day_stop));

$smarty->assign('friendly_names', $friendly_names);
$smarty->assign('sensors', $sensors);
$smarty->assign('new_sensor_id', count($sensors)+1);
$smarty->assign('temp_sensors', $temp_sensors);

$settings = $db->GetAll('select * from settings;');
$smarty->assign('settings', $settings);


$smarty->display('settings.tpl');
?>
