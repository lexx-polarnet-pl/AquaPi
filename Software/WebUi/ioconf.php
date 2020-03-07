<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2020 AquaPi Developers
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
$smarty->assign('title', 'Konfiguracja wejść/wyjść');

// dodawanie i kasowanie urządzeń
if(array_key_exists('action', $_GET))
{
	if ($_GET['action'] == "delete" and $_GET['device_id']>0)
	{
		$db->Execute('UPDATE interfaces SET interface_deleted=1 WHERE interface_id=?', array($_GET['device_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("ioconf.php");
	}
	elseif($_GET['action'] == "add")
	{
		$input_address = $_POST['InputAddressSelector'];
		if (isset($_POST['InputConf'])) { $conf=1; } else { $conf=0; }
		if ($_POST['FullyEditable']) {
			$input_address = $input_address.$_POST['FullyEditable'];
		}
		$db->Execute('INSERT INTO interfaces(interface_id, interface_address, interface_name, interface_type, interface_icon, interface_htmlcolor, interface_conf)
				     VALUES (?, ?, ?, ?, ?, ?, ?)',
				     array(0, $input_address, $_POST['InputFriendlyName'], $_POST["InputModeSelector"], $_POST['InputIconSelector'], substr($_POST['htmlcolor'],1), $conf));
		ReloadDaemonConfig();
	}	
} else {
	if($_POST) {
		foreach ($_POST['interfaces'] as $key => $interface) {
			if (isset($interface['conf'])) { $conf=1; } else { $conf=0; }
			if (isset($interface['draw'])) { $draw=1; } else { $draw=0; }
			if (isset($interface['dashboard'])) { $dashboard=1; } else { $dashboard=0; }
			if (!isset($interface['service_val'])) { $interface['service_val'] = -1; }
			$db->Execute('UPDATE interfaces SET interface_name = ?, interface_icon = ?, interface_htmlcolor = ?, interface_conf = ?, interface_draw = ?, interface_dashboard = ?, interface_uom = ?, interface_service_val = ?, interface_location = ? WHERE interface_id=?', array($interface['name'],$interface['img'],substr($interface['htmlcolor'],1),$conf,$draw,$dashboard,$interface['uom'],$interface['service_val'],$interface['location'],$key));
		}
		ReloadDaemonConfig();
	}
}

$icons 		= scandir('img/devices');
foreach($icons as $icon)
{
	if($icon === '.' or $icon === '..')
			{continue;}
	$result[] = $icon;
}
$icons	= $result;

// niech daemon powie jakie urządzena widzi
$device_list 	= @simplexml_load_string(IPC_CommandWithReply("devicelist"));

foreach ($device_list->devicelist->device as $value) {
	// sprawdź teraz czy te urządzenia nie są już skonfigurowane
	if (($db->GetOne("SELECT interface_id FROM interfaces WHERE interface_address ='?' AND interface_deleted <> 1",array($value->address)) > 0) && ($value->fully_editable_address !='yes')) {
		$value->addChild('configured', 'yes');

	}
}

$interfaces = GetInterfaces();
$uom = GetUnits();

$smarty->assign('icons', 		$icons);
$smarty->assign('device_list',	$device_list);
$smarty->assign('devices',		$interfaces);
$smarty->assign('uom',			$uom);

if ($device_list == false) {
	$smarty->display('daemon_missing.tpl');
} else {
	$smarty->display('ioconf.tpl');
};
?>

