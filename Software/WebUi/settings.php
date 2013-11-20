<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
 * Copyright (C) 2013 Jarosław Czarniak (jaroslaw@czarniak.org)
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
 
// Requires PHP 5.4 or higher 

//DOKONCZYC OPROGRAMOWANIE IKON !!!!!!!!

include("init.php");


//kasowanie urzadzen i interfejsów
if(array_key_exists('action', $_GET))
{
	if ($_GET['action'] == "delete" and $_GET['device_id']>0)
	{
		$db->Execute('UPDATE devices SET device_deleted=1 WHERE device_id=?', array($_GET['device_id']));
		//ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
	elseif($_GET['action'] == "delete" and $_GET['interface_id']>0)
	{
		$db->Execute('UPDATE interfaces SET interface_deleted=1 WHERE interface_id=?', array($_GET['interface_id']));
		//ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
}

//aktualizacja konfiguracji
if($_POST)
{
	//new dBug($_POST);
	//die;
	
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_1wire'],		'1wire'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_gpio'], 		'gpio'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_pwm'], 		'pwm'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_relayboard'], 	'relayboard'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_dummy'], 	'dummy'));
	
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['hysteresis'], 		'hysteresis'));	
	
	
	//1WIRE
	foreach($_POST['sensors'] as $interface_id => $sensor)
	{
		//jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		if(strlen($sensor['sensor_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			if(!$sensor['sensor_conf'] or $sensor_master==1)
				$sensor['sensor_master']=0;
			else
				$sensor_master=1;
			
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_address=?, interface_corr=?, interface_draw=?, interface_conf=? WHERE interface_id=?', 
				array($sensor['sensor_name'], $sensor['sensor_address'], $sensor['sensor_corr'], $sensor['sensor_draw'], $sensor['sensor_master'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj czujnik
		elseif(strlen($sensor['sensor_name'])>1) 
		{
                        if(!$sensor['sensor_draw'])
                            $sensor['sensor_draw']=0;
			$db->Execute('INSERT INTO interfaces(interface_id, interface_address, interface_name, interface_corr, interface_draw)
				     VALUES (?, ?, ?, ?, ?)', array($interface_id, $sensor['sensor_address'], $sensor['sensor_name'], $sensor['sensor_corr'], $sensor['sensor_draw']));
		}
		
	}
	
	//GPIO
	foreach($_POST['gpios'] as $interface_id => $gpio)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($gpio['gpio_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_address=? WHERE interface_id=?', 
				array($gpio['gpio_name'], $gpio['gpio_address'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj gpio
		elseif(strlen($gpio['gpio_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_address, interface_name)
				     VALUES (?, ?, ?)', array($interface_id, $gpio['gpio_address'], $gpio['gpio_name']));
		}
		
	}

	//RELAYBOARD
	foreach($_POST['relays'] as $interface_id => $relay)
	{
		$db->Execute('UPDATE interfaces SET interface_conf=? WHERE interface_id=?', 
			array($relay['relay_conf'], $interface_id ));
		
	}
	
	//DUMMY
	foreach($_POST['dummies'] as $interface_id => $dummy)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($dummy['dummy_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_conf=? WHERE interface_id=?', 
				array($dummy['dummy_name'], $dummy['dummy_conf'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj dummy
		elseif(strlen($dummy['dummy_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_address, interface_name, interface_conf)
				     VALUES (?, ?, ?, ?)', array($interface_id, $dummy['dummy_address'], $dummy['dummy_name'], $dummy['dummy_conf']));
		}
		
	}
	
	//ReloadDaemonConfig();
}




$devices	= GetDevices();
$interfaces	= GetInterfaces();
//new dbug($devices);
//new dbug($interfaces);
//die;

$hysteresis	= $db->GetOne("select setting_value from settings where `setting_key`='hysteresis';");
$icons 		= scandir('img');
foreach($icons as $icon)
{
	if($icon === '.' or $icon === '..'
		or $icon=='device.png'
		or pathinfo('img/'.$icon, PATHINFO_EXTENSION)!='png'
		or getimagesize('img/'.$icon)[0]>26
		)
			{continue;}
	$result[] = $icon;
}
$icons	= $result;

//new dBug($result);
//if($CONFIG['plugins']['relayboard']==1)
//{
//	include(MODULES_DIR . "relayboard.php");
//	$smarty->assign('relayboard_enable', 1);
//}


if(is_dir(ONEWIRE_DIR))
{
    $folder = dir(ONEWIRE_DIR);
    while($plik = $folder->read())
	if (substr($plik,0,3) == '28-')
		$sensors_fs[] = $plik;
    $folder->close();
}

$smarty->assign('hysteresis', $hysteresis);
if(isset($sensors_fs))
	$smarty->assign('sensors_fs', $sensors_fs);
else
{
	$smarty->assign('sensors_fs', 'FALSE');
	foreach($devices as $index => $device)
	{
		if($device['device_name']=='1wire')
		{
			unset($devices[$index]);
			break;
		}
	}
}

$smarty->assign('new_interface_id', $db->GetOne("select max(interface_id)+1 from interfaces"));
$smarty->assign('devices', $devices);
$smarty->assign('icons', $icons);
$smarty->assign('interfaces', $interfaces);
$smarty->assign('title', 'Ustawienia');
$smarty->display('settings.tpl');
?>

