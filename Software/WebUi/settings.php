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
 
// Requires PHP 5.4 or higher


include("init.php");
$smarty->assign('title', 'Ustawienia');

//kasowanie urzadzen i interfejsów
if(array_key_exists('action', $_GET))
{
	if ($_GET['action'] == "delete" and $_GET['device_id']>0 and $_GET['is_sure']==1)
	{
		$db->Execute('UPDATE devices SET device_deleted=1 WHERE device_id=?', array($_GET['device_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
	elseif($_GET['action'] == "delete" and $_GET['interface_id']>0 and $_GET['is_sure']==1)
	{
		$db->Execute('UPDATE interfaces SET interface_deleted=1 WHERE interface_id=?', array($_GET['interface_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
}


//aktualizacja konfiguracji
if($_POST)
{
	//new dBug($_POST,'',true);die;
	
	//UPDATE DEVICES
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_1wire'],		'1wire'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_gpio'], 		'gpio'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_pwm'], 		'pwm'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_relayboard'], 	'relayboard'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_dummy'], 	'dummy'));
	
	//SET GLOBAL SETTINGS
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['simplify_graphs']?$_POST['simplify_graphs']:0, 	'simplify_graphs'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(TimeToUnixTime($_POST['night_start']), 			'night_start'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(TimeToUnixTime($_POST['night_stop']),  			'night_stop'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['temp_night_corr'], 				'temp_night_corr'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['location'], 					'location'));
	
	
	//1WIRE
	foreach($_POST['sensors'] as $interface_id => $sensor)
	{
		//jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		if(strlen($sensor['sensor_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			if(!$sensor['sensor_conf'] or $sensor_master_set==1) //jesli nie jest ustawione lub już jakis inny został masterem
				$sensor['sensor_conf']=0;
			else
				$sensor_master_set=1;
			
			$db->Execute('UPDATE interfaces SET
						interface_name=?,
						interface_address=?,
						interface_corr=?,
						interface_nightcorr=?,
						interface_draw=?,
						interface_conf=?,
						interface_disabled=?
					WHERE interface_id=?', 
					array(
						$sensor['sensor_name'],
						'rpi:1w:'.$sensor['sensor_address'],
						$sensor['sensor_corr'],
						$sensor['sensor_nightcorr'],
						$sensor['sensor_draw'],
						$sensor['sensor_conf'],
						$sensor['sensor_disabled'],
						$interface_id
						));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($sensor['sensor_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($sensor['sensor_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($sensor['sensor_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($sensor['sensor_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj czujnik
		elseif(strlen($sensor['sensor_name'])>1) 
		{
                        if(!$sensor['sensor_draw'])
                            $sensor['sensor_draw']	= 0;
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_corr, interface_draw, interface_type)
				     VALUES (?, ?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('1wire'), 'rpi:1w:'.$sensor['sensor_address'], $sensor['sensor_name'], $sensor['sensor_corr'], $sensor['sensor_draw'], 1));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($sensor['sensor_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($sensor['sensor_unit'], $interface_id));
		}
		
		
		
	}
	
	//GPIO
	foreach($_POST['gpios'] as $interface_id => $gpio)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($gpio['gpio_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_address=?, interface_icon=?,  interface_draw=? WHERE interface_id=?', 
				array($gpio['gpio_name'], $gpio['gpio_address'], $gpio['gpio_icon'], $gpio['gpio_draw'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj gpio
		elseif(strlen($gpio['gpio_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_icon)
				     VALUES (?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('gpio'), $gpio['gpio_address'], $gpio['gpio_name'], 'device.png'));
		}
		
	}

	//RELAYBOARD
	foreach($_POST['relays'] as $interface_id => $relay)
	{
		if(!$relay['sensor_draw'])
                            $relay['sensor_draw']	= 0;
		$db->Execute('UPDATE interfaces SET interface_conf=?, interface_name=?, interface_icon=?, interface_draw=? WHERE interface_id=?', 
			array($relay['relay_conf'], $relay['relay_name'], $relay['relay_icon'], $relay['relay_draw'], $interface_id));
		
	}
	
	//DUMMY
	foreach($_POST['dummies'] as $interface_id => $dummy)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($dummy['dummy_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_conf=? WHERE interface_id=?', 
				array($dummy['dummy_name'], $dummy['dummy_conf'], $interface_id ));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($dummy['dummy_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($dummy['dummy_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($dummy['dummy_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($dummy['dummy_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj dummy
		elseif(strlen($dummy['dummy_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_conf, interface_type)
				     VALUES (?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('dummy'), 'dummy:'.$dummy['dummy_address'], $dummy['dummy_name'], $dummy['dummy_conf'], 1));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($dummy['dummy_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($dummy['dummy_unit'], $interface_id));
		}
	}
	
	//SYSTEM
	foreach($_POST['system'] as $interface_id => $system)
	{
		//jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		if(strlen($system['system_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces
					SET interface_name=?, interface_address=?, interface_corr=?, interface_nightcorr=?, interface_draw=?, interface_conf=?, interface_disabled=?
					WHERE interface_id=?', 
					array($system['system_name'], $system['system_address'], 0, 0, $system['system_draw'], 0, $system['system_disabled'], $interface_id ));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($system['system_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', 	array($system['system_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', 	array($system['system_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', 	array($system['system_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj czujnik
		elseif(strlen($system['system_name'])>1) 
		{
                        if(!$system['system_draw'])
                            $system['system_draw']=0;
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_corr, interface_draw)
				     VALUES (?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('system'), $system['system_address'], $system['system_name'], 0, $system['system_draw']));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($system['system_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', 	array($system['system_unit'], $interface_id));
		}
		
	}
	ReloadDaemonConfig();
	$SESSION->redirect("settings.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
}



$devices 	= GetDevices();
$interfaces	= GetInterfaces();
$units		= GetUnits();

//wyłaczenie relayboard jesli nie jest aktywne w konfigu
if($CONFIG['plugins']['relayboard']==0)
{
	foreach($devices as $index => $device)
	{
		if($device['device_name']=='relayboard')
			unset($devices[$index]);
	}
	$devices	= array_values($devices);
}

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

$wlist 		= xml2array(IPC_CommandWithReply("1wlist"));
$sensors_fs	= $wlist['aquapi']['list']['item'];

if(isset($sensors_fs))
	$smarty->assign('sensors_fs', $sensors_fs);


//new dBug($interfaces);
$smarty->assign('new_interface_id',	$db->GetOne("select max(interface_id)+1 from interfaces"));
$smarty->assign('devices', 		$devices);
$smarty->assign('units', 		$units);
$smarty->assign('icons', 		$icons);
$smarty->assign('interfaces', 		$interfaces);
$smarty->assign('simplify_graphs', 	$CONFIG['simplify_graphs']);
$smarty->assign('title', 		'Ustawienia');
$smarty->display('settings.tpl');
?>

